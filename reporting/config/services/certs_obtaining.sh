#!/bin/bash

while true; do echo "$(date -Iseconds) Certificates reloading with certbot..." && certbot renew; sleep $RENEWAL_CHECK_PERIOD; done;
