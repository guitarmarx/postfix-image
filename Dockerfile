FROM debian:10.1-slim

MAINTAINER meteorIT GbR Marcus Kastner

EXPOSE 25

ENV DB_HOST=localhost \
	DB_USER=kopano \
	DB_PASS=kopano \
	DB_NAME=kopano \
	ENCRYPT_SETTING=may\
	DOMAIN=localhost.local \
	KOPANO_HOST=localhost \
	SPAMCHECK_HOST=localhost \
	SPAMCHECK_PORT=11332 \
	IMAPPROXY_HOST=localhost \
	MAXIMAL_QUEUE_LIFETIME="12h" \
	BOUNCE_QUEUE_LIFETIME="4h" \
	DOCKERIZE_VERSION=v0.6.1


#DOMAIN_1 to DOMAIN_10 are possible(incl. KOPANO_HOST_1)
WORKDIR /srv

RUN apt-get update &&\
    {\
        echo "postfix postfix/mailname string $DOMAIN_1"; \
        echo  "postfix postfix/main_mailer_type string 'Internet Site'";\
    } | debconf-set-selections  \
	&& apt-get install -y --no-install-recommends postfix postfix-mysql sasl2-bin libsasl2-modules curl procps  net-tools\
	&& apt-get --purge -y remove 'exim4*'

# download dockerize
RUN curl -L https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz --output /tmp/dockerize.tar.gz  \
    && tar -C /usr/local/bin -xzvf /tmp/dockerize.tar.gz \
    && rm /tmp/dockerize.tar.gz

ADD template/ /srv/template
ADD scripts/ /srv/scripts

RUN chmod 755 /srv/scripts/*

HEALTHCHECK CMD bash /srv/scripts/healthcheck.sh
ENTRYPOINT ["/srv/scripts/entrypoint.sh"]
