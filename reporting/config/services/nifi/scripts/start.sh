#!/bin/bash

: ${POSTGRES_PASSWORD:?"Need to set POSTGRES_PASSWORD"}
: ${AUTH_SERVER_CLIENT_ID:?"Need to set AUTH_SERVER_CLIENT_ID"}
: ${AUTH_SERVER_CLIENT_SECRET:?"Need to set AUTH_SERVER_CLIENT_SECRET"}
: ${TRUSTED_HOSTNAME:?"Need to set TRUSTED_HOSTNAME"}

cp /config/nifi/libs/* lib/ &&
/config/nifi/scripts/download-toolkit.sh $1 &&
/config/nifi/scripts/preload.sh init $1 ${POSTGRES_PASSWORD} ${AUTH_SERVER_CLIENT_SECRET} ${AUTH_SERVER_CLIENT_ID} ${TRUSTED_HOSTNAME} &&
cd /opt/nifi/nifi-$1 &&
../scripts/start.sh
