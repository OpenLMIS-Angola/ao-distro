#!/bin/bash

while true; do echo "$(date -Iseconds) Nginx certificates reloading..." && nginx -s reload; sleep $RENEWAL_CHECK_PERIOD; done
