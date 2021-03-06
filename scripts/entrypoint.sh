#!/bin/bash
set -e


#Setzen des Hostnames
export HOSTNAME=`hostname`

# create lmtp mappings
dockerize -wait tcp://$DB_HOST:3306 -timeout 60s
echo "create tables ..."
mysql -h $DB_HOST -u $DB_USER --password=$DB_PASS $DB_NAME < /srv/scripts/create_tables.txt

# config postfix
dockerize -template /srv/template/postfix:/etc/postfix
usermod -a -G sasl postfix


# prepare sasl
cp /srv/template/saslauthd/smtpd.conf /etc/postfix/sasl/smtpd.conf
mkdir -p /var/spool/postfix/var/run/saslauthd
rm -rf /run/saslauthd
ln -s /var/spool/postfix/var/run/saslauthd   /run/saslauthd

# start postfix
service postfix start
postfix reload

# start sasl (when imapproxy host is available)
if ! [ -z "$IMAP_HOST" ]; then
    dockerize -wait tcp://$IMAP_HOST:143 -timeout 60s
    saslauthd -a rimap -O "$IMAP_HOST" -V -r -m /var/spool/postfix/var/run/saslauthd
fi

tail -f /var/log/postfix.log