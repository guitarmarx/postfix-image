#!/bin/bash

#Setzen des Hostnames
FQDN=`hostname`.$DOMAIN

#Erstellen der Domänenabhängigen Konfigurationen
if [ ! -z $DOMAIN ] && [ ! -z $KOPANO_HOST_1 ]; then
        echo $DOMAIN "lmtp:["${KOPANO_HOST_1}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN registriert"
fi
if [ ! -z $RELAY_DOMAIN_2 ] && [ ! -z $KOPANO_HOST_2 ]; then
        echo $RELAY_DOMAIN_2 "lmtp:["${KOPANO_HOST_2}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_2 registriert"
fi
if [ ! -z $RELAY_DOMAIN_3 ] && [ ! -z $KOPANO_HOST_3 ]; then
        echo $RELAY_DOMAIN_3 "lmtp:["${KOPANO_HOST_3}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_3 registriert"
fi
if [ ! -z $RELAY_DOMAIN_4 ] && [ ! -z $KOPANO_HOST_4 ]; then
        echo $RELAY_DOMAIN_4 "lmtp:["${KOPANO_HOST_4}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_4 registriert"
fi
if [ ! -z $RELAY_DOMAIN_5 ] && [ ! -z $KOPANO_HOST_5 ]; then
        echo $RELAY_DOMAIN_5 "lmtp:["${KOPANO_HOST_5}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_5 registriert"
fi
if [ ! -z $RELAY_DOMAIN_6 ] && [ ! -z $KOPANO_HOST_6 ]; then
        echo $RELAY_DOMAIN_6 "lmtp:["${KOPANO_HOST_6}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_6 registriert"
fi
if [ ! -z $RELAY_DOMAIN_7 ] && [ ! -z $KOPANO_HOST_7 ]; then
        echo $RELAY_DOMAIN_7 "lmtp:["${KOPANO_HOST_7}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_7 registriert"
fi
if [ ! -z $RELAY_DOMAIN_8 ] && [ ! -z $KOPANO_HOST_8 ]; then
        echo $RELAY_DOMAIN_8 "lmtp:["${KOPANO_HOST_8}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_8 registriert"
fi
if [ ! -z $RELAY_DOMAIN_9 ] && [ ! -z $KOPANO_HOST_9 ]; then
        echo $RELAY_DOMAIN_9 "lmtp:["${KOPANO_HOST_9}"]:2003" >> /etc/postfix/transport
		echo "$RELAY_DOMAIN_9 registriert"
fi

postmap /etc/postfix/transport
usermod -a -G sasl postfix

#Anpassen der Postfix Config und der Aliase
dockerize  -template /tmp/template/postfix/mysql-virtual-alias-maps.cf.tmpl:/etc/postfix/mysql-virtual-alias-maps.cf
dockerize  -template /tmp/template/postfix/main.cf.tmpl:/etc/postfix/main.cf

#Starten des Sasl Dienstes
service rsyslog start
cp /tmp/template/saslauthd/smtpd.conf /etc/postfix/sasl/smtpd.conf
mkdir -p /var/spool/postfix/var/run/saslauthd
rm -rf /run/saslauthd
ln -s /var/spool/postfix/var/run/saslauthd   /run/saslauthd
saslauthd -a rimap -O "$IMAPPROXY_HOST" -V -r -m /var/spool/postfix/var/run/saslauthd


#Starten von Postfix
service postfix start
postfix reload


tail -f /var/log/mail.info

