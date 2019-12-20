#!/bin/bash
set -x

GIT_URL=$1
BRANCH=$2

# Replace Stakater Platform URL and Branch names
replace_flux_values () {
  sed -i -e "s#STAKATER_PLATFORM_SSH_GIT_URL#${GIT_URL}#g" flux.yaml
  sed -i -e "s#STAKATER_PLATFORM_BRANCH#${BRANCH}#g" flux.yaml
}

replace_flux_values