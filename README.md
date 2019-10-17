# Postfix Docker Image for Relay Domains

This docker image uses postfix to relay given domains to different lmtp hosts.
It also contains sasl rimap for imap server authentication if enabled

## Build image
```sh
git clone https://github.com/guitarmarx/postfix-image.git
cd postfix-image
docker build -t <imagename:version> .
```

## Quickstart

### Docker (standalone)
```sh
docker run -d  \
    -p 25:25 \
    -e DB_HOST=<mysql host> \
    -e DB_USER=postfix \
    -e DB_PASS=postfix \
    -e DB_NAME=postfix \
    -e SPAMCHECK_HOST=<your anti spam server> \
    -e DOMAIN=<your domain name> \
    --hostname `hostname` \
    -v <path>/cert.pem:/srv/cert/cert.pem:ro \
    -v <path>/privkey.pem:/srv/cert/privkey.pem:ro \
    -v <path>/fullchain.pem:/srv/cert/fullchain.pem:ro \
    <imagename>:<version>
```

### Docker Swarm
```sh
docker run -d  \
    -p 25:25 \
    -e DB_HOST=<mysql host> \
    -e DB_USER=postfix \
    -e DB_PASS=postfix \
    -e DB_NAME=postfix \
    -e SPAMCHECK_HOST=<your anti spam server> \
    -e DOMAIN=<your domain name> \
    --hostname "{{.Node.Hostname}}" \
    --mount type=bind,src=<path>/cert.pem,dst=/srv/cert/cert.pem,readonly \
    --mount type=bind,src=<path>/privkey.pem,dst=/srv/cert/privkey.pem,readonly \
    --mount type=bind,src=<path>/fullchain.pem,dst=/srv/cert/fullchain.pem,readonly \
    <imagename>:<version>
```


# Configuration

Parameter | Function| Default Value|
---|---|---|
DB_HOST | (required) Mysql Database Host | localhost
DB_APP | (required) Mysql Database Name | postfix
DB_USER | (required) Mysql Database Host | postfix
DB_PASS | (required) Mysql Database Password | postfix
SPAMCHECK_HOST | (required) Server for spam filtering | localhost
IMAPPROXY_HOST | (required)
SPAMCHECK_PORT | Portfor spam filter | 11332


DB_HOST=localhost \
	DB_USER=postfix \
	DB_PASS=postfix \
	DB_NAME=postfix \
	ENCRYPT_SETTING=may \
	DOMAIN=localhost.local \
	SPAMCHECK_HOST=localhost \
	SPAMCHECK_PORT=11332 \
	IMAP_HOST=localhost \
	MAXIMAL_QUEUE_LIFETIME="12h" \
	BOUNCE_QUEUE_LIFETIME="4h" \
	DOCKERIZE_VERSION=v0.6.1
