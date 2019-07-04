#!/bin/bash

: ${RENEWAL_CHECK_PERIOD:?"Need to set RENEWAL_CHECK_PERIOD"}

while true; do echo "$(date -Iseconds) Nginx certificates reloading..." && nginx -s reload; sleep $RENEWAL_CHECK_PERIOD; done
