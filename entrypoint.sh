#!/bin/bash

#Setzen des Hostnames
FQDN=$DOMAIN_1
if [ "$USE_FQDN_FROM_HOST" == "TRUE" ];then

        HOSTSFILE_PATH=/tmp/hosts
        if [ -f $HOSTSFILE_PATH ]; then
                FQDN=`cat /tmp/hosts | grep 127.0.1.1 | cut -f 2 | cut -d " " -f 1`
                echo Hostname set to: $FQDN
        else
                echo "fqdn from host can't be set, please mount /etc/hosts with '-v /etc/hosts:/tmp/hosts:ro'"
        fi
fi



#Erstellen der Domänenabhängigen Konfigurationen
if [ ! -z $DOMAIN_1 ] && [ ! -z $KOPANO_HOST_1 ]; then
        echo $DOMAIN_1 "lmtp:["${KOPANO_HOST_1}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_1 registriert"
fi
if [ ! -z $DOMAIN_2 ] && [ ! -z $KOPANO_HOST_2 ]; then
        echo $DOMAIN_2 "lmtp:["${KOPANO_HOST_2}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_2 registriert"
fi
if [ ! -z $DOMAIN_3 ] && [ ! -z $KOPANO_HOST_3 ]; then
        echo $DOMAIN_3 "lmtp:["${KOPANO_HOST_3}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_3 registriert"
fi
if [ ! -z $DOMAIN_4 ] && [ ! -z $KOPANO_HOST_4 ]; then
        echo $DOMAIN_4 "lmtp:["${KOPANO_HOST_4}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_4 registriert"
fi
if [ ! -z $DOMAIN_5 ] && [ ! -z $KOPANO_HOST_5 ]; then
        echo $DOMAIN_5 "lmtp:["${KOPANO_HOST_5}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_5 registriert"
fi
if [ ! -z $DOMAIN_6 ] && [ ! -z $KOPANO_HOST_6 ]; then
        echo $DOMAIN_6 "lmtp:["${KOPANO_HOST_6}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_6 registriert"
fi
if [ ! -z $DOMAIN_7 ] && [ ! -z $KOPANO_HOST_7 ]; then
        echo $DOMAIN_7 "lmtp:["${KOPANO_HOST_7}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_7 registriert"
fi
if [ ! -z $DOMAIN_8 ] && [ ! -z $KOPANO_HOST_8 ]; then
        echo $DOMAIN_8 "lmtp:["${KOPANO_HOST_8}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_8 registriert"
fi
if [ ! -z $DOMAIN_9 ] && [ ! -z $KOPANO_HOST_9 ]; then
        echo $DOMAIN_9 "lmtp:["${KOPANO_HOST_9}"]:2003" >> /etc/postfix/transport
		echo "$DOMAIN_9 registriert"
fi

postmap /etc/postfix/transport
usermod -a -G sasl postfix

#Anpassen der Postfix Config und der Aliase
envsubst < /tmp/template/postfix/mysql-virtual-alias-maps.cf.tmpl > /etc/postfix/mysql-virtual-alias-maps.cf
FQDN=$FQDN envsubst < /tmp/template/postfix/main.cf.tmpl > /etc/postfix/main.cf


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

