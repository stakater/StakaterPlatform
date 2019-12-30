#!/bin/bash
source ../variables.config

replace_values() {
  VALUE_TO_REPLACE = ${2}
  if [ -z "$3" ] ; then
    VALUE_TO_REPLACE=`echo -n $2 | base64`
  fi

  echo "Value to replace : $VALUE_TO_REPLACE"

  find ../platform -type f -name "*.yaml" -print0 | xargs -0 sed -i -e "s#${1}#${VALUE_TO_REPLACE}#g"
  find ../config -type f -name "*.*" -print0 | xargs -0 sed -i -e "s#${1}#${VALUE_TO_REPLACE}#g"
}

replace_values CLOUD_PROVIDER $CLOUD_PROVIDER && \
replace_values DOMAIN $DOMAIN && \
replace_values SSL_CERTIFICATE_CA_CRT $SSL_CERTIFICATE_CA_CRT && \
replace_values SSL_CERTIFICATE_TLS_CRT $SSL_CERTIFICATE_TLS_CRT && \
replace_values SSL_CERTIFICATE_TLS_KEY $SSL_CERTIFICATE_TLS_KEY && \
replace_values STAKATER_PLATFORM_SSH_GIT_URL $STAKATER_PLATFORM_SSH_GIT_URL && \
replace_values STAKATER_PLATFORM_BRANCH $STAKATER_PLATFORM_BRANCH && \
replace_values USER_MAIL $USER_MAIL && \
replace_values USER_NAME $USER_NAME && \
replace_values REPO_ACCESS_TOKEN $REPO_ACCESS_TOKEN && \
replace_values DOMAIN $DOMAIN


# TODO once values are replaced convert all configs to base64 encoded values

if [ $?==0 ]; then
  exit 0
else
  exit 1
fi