#!/bin/bash

CRTDIR=etc/certbot/live
DOMAIN=test.com

# Clear logs
[ "$(ls -A log)" ] && find log -name "*.log" -exec tee {} + </dev/null

# 1st. Generate/Update certificates
if [ -d ${CRTDIR} ]; then
  docker-compose run --rm --entrypoint "certbot renew" certbot
else
  docker-compose up certbot
fi

# 2nd. Concat certificates with private key (for haproxy)
cat ${CRTDIR}/${DOMAIN}/fullchain.pem ${CRTDIR}/${DOMAIN}/privkey.pem > ${CRTDIR}/${DOMAIN}/${DOMAIN}.pem

# 3rd. Running all services
docker-compose up -d haproxy

# 4th. Create crontab task
[ ! -f "/etc/cron.d/docker-v2ray" ] && echo "0 4 * * 0 cd ${PWD} && ./deploy.sh" > /etc/cron.d/docker-v2ray
