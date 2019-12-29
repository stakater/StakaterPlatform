#!/bin/bash

echo -e "\n========= Testing Stakater Endpoints ==========\n"

HOST_NAMES=$(kubectl get ingress --all-namespaces | awk '{print $3}' | grep '\.')
for HOST_NAME in $HOST_NAMES; do
  curl -sL -w "%{http_code} URL=%{url_effective}\\n\\n" "https://$HOST_NAME" -o /dev/null
  #TODO add asserts(200 & 301) here
done

echo -e "\n========= Testing Ended =========="
