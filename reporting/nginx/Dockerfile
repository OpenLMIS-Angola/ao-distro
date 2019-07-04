FROM nginx:1.12-alpine

RUN mkdir -p /etc/nginx/ /var/www/certbot /etc/letsencrypt/live

RUN apk update \
    && apk add ca-certificates && update-ca-certificates \
    && apk add openssl \
    && apk add curl \
    && rm -rf /var/cache/apk/*
RUN wget -O /etc/nginx/options-ssl-nginx.conf \
    https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/options-ssl-nginx.conf
RUN wget -O /etc/nginx/ssl-dhparams.pem \
    https://raw.githubusercontent.com/certbot/certbot/master/certbot/ssl-dhparams.pem

COPY run_with_template.sh /etc/nginx/run_with_template.sh
RUN chmod +x /etc/nginx/run_with_template.sh

CMD /bin/sh -c 'nginx -g "daemon off;"'
VOLUME [ "/var/log/nginx", "/etc/letsencrypt", "/var/www/certbot" ]
