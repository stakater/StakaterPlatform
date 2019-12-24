#!/bin/bash
set -x

# Flux
GIT_URL=${1}
BRANCH=${2}
# Domain to configure on e.g. stakater.com
DOMAIN=${3}
# Control: External-dns
AWS_ACCESS_KEY_ID=${4}
AWS_SECRET_ACCESS_KEY=${5}
# Control: IMC
IMC_CONFIG=${6}
# Delivery: Jenkins
JENKINS_CFG=${7}
KEYCLOAK_CLIENT_ID=${8}
KEYCLOAK_CLIENT_SECRET=${9}
HUB_TOKEN=${10}
GITLAB_TOKEN=${11}
BITBUCKET_TOKEN=${12}
# Delivery: Nexus
ADMIN_ACCOUNT_JSON=${13}
CLUSTER_ACCOUNT_JSON=${14}
ADMIN_ACCOUNT_USERNAME=${15}
CLUSTER_ACCOUNT_USERNAME=${16}
# Monitoring: alertmanager
ALERTMANAGER_CONFIG=${17}
# Security: KeyCloak
KEYCLOAK_CONFIG=${18}
# Security: ProxyInjector
PROXYINJECTOR_CONFIG=${19}

# Slack Config
SLACK_CHANNEL=${20}
SLACK_URL=${21}

# Replace Stakater Platform URL and Branch names
# replace_flux_values () {
#   sed -i -e "s#STAKATER_PLATFORM_SSH_GIT_URL#${GIT_URL}#g" flux.yaml
#   sed -i -e "s#STAKATER_PLATFORM_BRANCH#${BRANCH}#g" flux.yaml
# }

replace_aws_creds_values () {
  sed -i -e "s#BASE64_ENCODED_AWS_ACCESS_KEY_ID#${AWS_ACCESS_KEY_ID}#g" platform/control/secret-aws-creds.yaml
  sed -i -e "s#BASE64_ENCODED_AWS_SECRET_ACCESS_KEY#${AWS_SECRET_ACCESS_KEY}#g" platform/control/secret-aws-creds.yaml
}

replace_imc_values () {
  sed -i -e "s#BASE64_ENCODED_IMC_CONFIG#${IMC_CONFIG}#g" platform/control/secret-imc-config.yaml
}

replace_jenkins_values () {
  sed -i -e "s#BASE64_ENCODED_JENKINS_CFG#${JENKINS_CFG}#g" platform/delivery/secret-jenkins-cfg.yaml
  sed -i -e "s#KEYCLOAK_CLIENT_ID#${KEYCLOAK_CLIENT_ID}#g" platform/delivery/jenkins.yaml
  sed -i -e "s#BASE64_ENCODED_SLACK_CHANNEL#${SLACK_CHANNEL}#g" platform/delivery/secret-slack-hook.yaml
  sed -i -e "s#BASE64_ENCODED_SLACK_WEBHOOK_URL#${SLACK_URL}#g" platform/delivery/secret-slack-hook.yaml
  sed -i -e "s#KEYCLOAK_CLIENT_SECRET#${KEYCLOAK_CLIENT_SECRET}#g" platform/delivery/jenkins.yaml
  sed -i -e "s#BASE64_ENCODED_HUB_TOKEN#${HUB_TOKEN}#g" platform/delivery/secret-jenkinshub-api-token.yaml
  sed -i -e "s#BASE64_ENCODED_GITLAB_TOKEN#${GITLAB_TOKEN}#g" platform/delivery/secret-jenkinshub-api-token.yaml
  sed -i -e "s#BASE64_ENCODED_BITBUCKET_TOKEN#${BITBUCKET_TOKEN}#g" platform/delivery/secret-jenkinshub-api-token.yaml
}

replace_nexus_values () {
  sed -i -e "s#BASE64_ENCODED_ADMIN_ACCOUNT_JSON#${ADMIN_ACCOUNT_JSON}#g" platform/delivery/nexus.yaml
  sed -i -e "s#BASE64_ENCODED_CLUSTER_ACCOUNT_JSON#${CLUSTER_ACCOUNT_JSON}#g" platform/delivery/nexus.yaml
  sed -i -e "s#NEXUS_ADMIN_ACCOUNT_USERNAME#${ADMIN_ACCOUNT_USERNAME}#g" platform/delivery/nexus.yaml
  sed -i -e "s#NEXUS_CLUSTER_ACCOUNT_USERNAME#${CLUSTER_ACCOUNT_USERNAME}#g" platform/delivery/nexus.yaml
}

replace_alertmanager_values () {
  sed -i -e "s#BASE64_ENCODED_ALERTMANAGER_CONFIG#${ALERTMANAGER_CONFIG}#g" platform/monitoring/secret-alertmanager-config.yaml
}

replace_keycloak_values () {
  sed -i -e "s#BASE64_ENCODED_KEYCLOAK_CONFIG#${KEYCLOAK_CONFIG}#g" platform/security/secret-keycloak-config.yaml
}

replace_proxyinjector_values () {
  sed -i -e "s#BASE64_ENCODED_PROXYINJECTOR_CONFIG#${PROXYINJECTOR_CONFIG}#g" platform/security/secret-pi-config.yaml
}

replace_domain () {
  find ./platform/ -type f -exec sed -i -e "s#DOMAIN#${DOMAIN}#g" {} \;
}


replace_domain && \
# replace_flux_values && \
replace_aws_creds_values && \
replace_imc_values && \
replace_jenkins_values && \
replace_nexus_values && \
replace_alertmanager_values && \
replace_keycloak_values && \
replace_proxyinjector_values && \

if [ $?==0 ]; then
  exit 0
else
  exit 1
fi