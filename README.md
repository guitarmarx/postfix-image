# Postfix Docker Image for Relay Domains

The image uses postfix to relay given domains to lmtp host's.
if enabled (IMAP_HOST parameter) you can use sasl rimap authentication to authenticate against an imap server

## Build image
```sh
git clone https://github.com/guitarmarx/postfix-image.git
cd postfix-image
docker build -t <imagename:version> .
```

## Requirements
You need a running mysql database to add aliase and lmtp transport mappings

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
DOMAIN | Server Domain | localhost.local
DB_HOST | (required) Mysql Database Host | localhost
DB_APP | (required) Mysql Database Name | postfix
DB_USER | (required) Mysql Database Host | postfix
DB_PASS | (required) Mysql Database Password | postfix
SPAMCHECK_HOST | (required) Server for spam filtering | localhost
SPAMCHECK_PORT | (optional) Portfor spam filter | 11332
IMAP_HOST | (optimal) IMAP Host for rimap auth |
IMAP_HOST | (optimal) IMAP Host for rimap auth |
ENCRYPT_SETTING | (optimal) set's the parameter smtp_tls_security_level | may

## Aliases and lmtp transportmapping
the image creates 2 tables when started:
- virtual_aliases (for aliases)
- transport (lmtp mapping)

To add aliases or lmtp transport mapping simply
execute the following statements in your mysql database:
```sql
insert into transport (alias, email) VALUES ('<alias@domain>', 'email');
insert into transport (domain, destination) VALUES ('<domain>', 'lmtp:[<target host>]:2003');
```