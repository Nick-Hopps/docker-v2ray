#!/bin/bash

# ======================
DOMAIN=example.com
# ======================

CRTDIR=./etc/certbot/live/${DOMAIN}

# 1st. Generating let's encrypt certificate
[ ! -d ${CRTDIR} ] && docker-compose up certbot

# 2nd. Concat certificate with private key
cat ${CRTDIR}/fullchain.pem ${CRTDIR}/privkey.pem > ${CRTDIR}/${DOMAIN}.pem

# 3rd. Running all services
docker-compose up -d haproxy v2ray

# 4th. Create crontab task for renewing certificate
[ $? -eq 0 ] && cp -f ./certbot /etc/cron.d/certbot
