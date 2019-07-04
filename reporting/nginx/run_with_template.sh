#!/bin/bash

if [ "$1" == "-d" ]; then runInDaemon=true; else runInDaemon=false; fi

all_system_env=$(env | cut -f1 -d"=" | awk '{print "$"$0""}' | tr '\n' ' ')
envsubst "$all_system_env" < /etc/nginx/nginx.tmpl > /etc/nginx/nginx.conf &&
nginx -t && # config validation

if [ $runInDaemon == "true" ]; then
    echo "Running nginx in daemon mode..."
    nginx || (echo "nginx error" && cat /etc/nginx/nginx.conf)
else
    echo "Running nginx in foreground..."
    nginx -g "daemon off;" || (echo "nginx error" && cat /etc/nginx/nginx.conf)
fi
