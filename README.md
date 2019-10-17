# Postfix Docker Image for Relay Domains

This docker image uses postfix to relay all given domains to different lmtp hosts.
It also contains sasl rimap for imap server authentication

#### Requirements



## Quickstart

### Docker (single node)
```sh
docker run -d  \
    -p 25:25 \
    -e DB_HOST=dbhost \
    -e DB_USER=postfix \
    -e DB_PASS=postfix \
    -e DB_NAME=postfix \
    -e SPAMCHECK_HOST=${Umgebung}_rspamd \
    -e IMAPPROXY_HOST=${Umgebung}_perdition \
    -e SPAMCHECK_PORT=11332 \
    -e DOMAIN=meteor-qs.de \
    -e RELAY_HOST_PAIR1="demo1.meteor-qs.de,demo1_kopano" \
    --hostname "{{.Node.Hostname}}" \
    --name postfix \
    --mount type=bind,source=/etc/localtime,destination=/etc/localtime,ro \
    --mount type=bind,source=${CERTVOLUME_SRC},destination=${CERTVOLUME_DST} \
    --label environment=$Umgebung \
    --constraint node.labels.application==yes \
    $IMAGE
```

### Docker Swarm
```sh
docker run -d  \
    --publish published=25,target=25,mode=host \
    -e DB_HOST=${Umgebung}_database \
    -e DB_USER=postfix \
    -e DB_PASS=postfix \
    -e DB_NAME=postfix \
    -e SPAMCHECK_HOST=${Umgebung}_rspamd \
    -e IMAPPROXY_HOST=${Umgebung}_perdition \
    -e SPAMCHECK_PORT=11332 \
    -e DOMAIN=meteor-qs.de \
    -e RELAY_HOST_PAIR1="demo1.meteor-qs.de,demo1_kopano" \
    -e RELAY_HOST_PAIR2="demo2.meteor-qs.de,demo2_kopano" \
    -e RELAY_HOST_PAIR3="demo3.meteor-qs.de,demo3_kopano" \
    -e RELAY_HOST_PAIR4="demo4.meteor-qs.de,demo4_kopano" \
    -e RELAY_HOST_PAIR5="test1.meteor-qs.de,test1_kopano" \
    -e RELAY_HOST_PAIR6="test2.meteor-qs.de,test2_kopano" \
    -e RELAY_HOST_PAIR7="dev.meteor-qs.de,dev_kopano" \
    --hostname "{{.Node.Hostname}}" \
    --mode global \
    --name ${Umgebung}_$CONTAINER_NAME \
    --mount type=bind,source=/etc/localtime,destination=/etc/localtime,ro \
    --mount type=bind,source=${CERTVOLUME_SRC},destination=${CERTVOLUME_DST} \
    --label environment=$Umgebung \
    --constraint node.labels.application==yes \
    --with-registry-auth \
    $Netzwerke \
    $IMAGE
```


#### Run Container
```sh
docker run -d \
        -e NETCUP_USER=<NETCUP_USER> \
        -e NETCUP_PASSWORD=<NETCUP_PASSWORD> \
        -e FAILOVER_IP=<FAILOVER_IP> \
        -e FAILOVER_SERVER_1=<FAILOVER_SERVER_1> \
        -e FAILOVER_SERVER_MAC_1=<FAILOVER_SERVER_MAC_1> \
        <image>:<version>
```

# Configuration
#### Optional Parameters:

You can add multiple netcup server for the failover with the parameters FAILOVER_SERVER_1 and  FAILOVER_SERVER_MAC_1. Just increment the last number.

Parameter | Function| Default Value|
---|---|---|
DB_HOST | (required) Mysql Database Host | localhost
DB_APP | (required) Mysql Database Name | postfix
DB_USER | (required) Mysql Database Host | postfix
DB_PASS | (required) Mysql Database Password | postfix
SPAMCHECK_HOST | (required) Server for spam filtering | localhost
IMAPPROXY_HOST | (required)
SPAMCHECK_PORT | Portfor spam filter | 11332




	MAXIMAL_QUEUE_LIFETIME="12h" \
	BOUNCE_QUEUE_LIFETIME="4h" \
	DOCKERIZE_VERSION=v0.6.1


    -e IMAPPROXY_HOST=${Umgebung}_perdition \
    -e SPAMCHECK_PORT=11332 \
    -e DOMAIN=meteor-qs.de \
    -e RELAY_HOST_PAIR1="demo1.meteor-qs.de,demo1_kopano" \
    -e RELAY_HOST_PAIR2="demo2.meteor-qs.de,demo2_kopano" \
    -e RELAY_HOST_PAIR3="demo3.meteor-qs.de,demo3_kopano" \
    -e RELAY_HOST_PAIR4="demo4.meteor-qs.de,demo4_kopano" \
    -e RELAY_HOST_PAIR5="test1.meteor-qs.de,test1_kopano" \
    -e RELAY_HOST_PAIR6="test2.meteor-qs.de,test2_kopano" \
    -e RELAY_HOST_PAIR7="dev.meteor-qs.de,dev_kopano" \







#postmap -q t@meteor-qs.de mysql:/etc/postfix/mysql-virtual-alias-maps.cf -->




