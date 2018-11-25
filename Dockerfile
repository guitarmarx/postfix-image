FROM debian:9

MAINTAINER meteorIT GbR Marcus Kastner

EXPOSE 25

ENV DB_HOST=localhost \
	DB_USER=kopano \
	DB_PASS=kopano \
	DB_NAME=kopano \
	ENCRYPT_SETTING=may\
	DOMAIN_1=localhost.local\
	KOPANO_HOST_1=localhost \
	SPAMCHECK_HOST=localhost \
	SPAMCHECK_PORT=11332 \
	IMAPPROXY_HOST=localhost \
	USE_FQDN_FROM_HOST=FALSE \
	MAXIMAL_QUEUE_LIFETIME="2h" \
	BOUNCE_QUEUE_LIFETIME="2h"


#DOMAIN_1 to DOMAIN_10 are possible(incl. KOPANO_HOST_1)
#USE_FQDN_FROM_HOST needs the following volume: -v /etc/hosts:/tmp/hosts:ro

WORKDIR /tmp

RUN apt-get update &&\
    {\
        echo "postfix postfix/mailname string $DOMAIN_1"; \
        echo  "postfix postfix/main_mailer_type string 'Internet Site'";\
    } | debconf-set-selections  \
	&& apt-get install -y rsyslog postfix postfix-mysql sasl2-bin libsasl2-modules gettext vim \
	&& apt-get --purge -y remove 'exim4*'


ADD template/ /tmp/template
ADD entrypoint.sh /tmp

RUN chmod 755 /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
