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

replace_values STAKATER_PLATFORM_SSH_GIT_URL $STAKATER_PLATFORM_SSH_GIT_URL && \
replace_values KEYCLOAK_CLIENT_ID $KEYCLOAK_CLIENT_ID


# TODO once values are replaced convert all configs to base64 encoded values

if [ $?==0 ]; then
  exit 0
else
  exit 1
fi