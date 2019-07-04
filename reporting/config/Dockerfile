FROM certbot/certbot:v0.33.1

COPY ./services /config

RUN apk update && apk upgrade && \
    apk add curl && \
    apk add bash && \
    apk add bash-completion && \
    rm -rf /var/cache/apk/*

ENTRYPOINT [""]
CMD [""]
