#!/bin/bash
set -e


#Setzen des Hostnames
export HOSTNAME=`hostname`

# create lmtp mappings
# wait for db
dockerize -wait tcp://$DB_HOST:$DB_PORT
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
echo "wait for imapproxy host $IMAPPROXY_HOST:143 ..."$IMAPPROXY_HOST:143
dockerize -wait tcp://$IMAPPROXY_HOST:143
saslauthd -a rimap -O "$IMAPPROXY_HOST" -V -r -m /var/spool/postfix/var/run/saslauthd


tail -f /var/log/postfix.log