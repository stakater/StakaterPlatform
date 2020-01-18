#!/bin/bash
source variables.config

replace_values() {
  VALUE_TO_REPLACE=${2}
  if [ "$3" = "ENCODE" ] ; then
    # TODO convert to sealed-secret here
    VALUE_TO_REPLACE=`echo -n $2 | base64 -w 0`
  fi

  find platform/nordmart -type f -name "*.yaml" -print0 | xargs -0 sed -i "s|${1}|${VALUE_TO_REPLACE}|g"
  find configs/ -type f -name "*.*" -print0 | xargs -0 sed -i "s|${1}|${VALUE_TO_REPLACE}|g"
}

replace_configs() {
    VALUE_TO_REPLACE=`cat $2 | base64 -w 0`
    find platform/ -type f -name "*.*" -print0 | xargs -0 sed -i "s|${1}|${VALUE_TO_REPLACE}|g"
}

replace_values DOMAIN $DOMAIN && \
replace_values DNS_PROVIDER $DNS_PROVIDER && \
replace_values STORAGE_CLASS_NAME stakater-storageclass && \
replace_values BASE64_ENCODED_SSL_CERTIFICATE_TLS_CRT $BASE64_ENCODED_SSL_CERTIFICATE_TLS_CRT && \
replace_values BASE64_ENCODED_SSL_CERTIFICATE_TLS_KEY $BASE64_ENCODED_SSL_CERTIFICATE_TLS_KEY && \
replace_values EXTERNAL_DNS_AWS_ACCESS_KEY_ID $EXTERNAL_DNS_AWS_ACCESS_KEY_ID ENCODE && \
replace_values EXTERNAL_DNS_AWS_SECRET_ACCESS_KEY $EXTERNAL_DNS_AWS_SECRET_ACCESS_KEY ENCODE && \
replace_values JENKINS_NEXUS_AUTH "$NEXUS_ADMIN_ACCOUNT_USER:$NEXUS_ADMIN_ACCOUNT_PASSWORD" ENCODE && \

replace_configs "<concealed>" configs/jenkins.json && \

find platform/nordmart -type f -name "*.yaml" -print0 | xargs -0 sed -i "s|policy: sync|policy: upsert-only|g"

if [ $?==0 ]; then
  exit 0
else
  exit 1
fi