#!/bin/bash

while ! (http_code=$(curl -w %{http_code} -s -o /dev/null http://nginx-nifi) && ([ "$http_code" == "200" ] || [ "$http_code" == "301" ] || [ "$http_code" == "401" ])); do sleep 1; done
echo "Nginx-nifi is ready"
