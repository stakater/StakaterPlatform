# StakaterPlatform

## Overview 
Stakater platform provides out of the box stacks to control, monitor, log, trace and security for applications deployed on kubernetes using CI/CD pipelines.

Stakater Platform consist of 6 stacks
- [Control](https://playbook.stakater.com/content/stacks/control.html)
- [Delivery](https://playbook.stakater.com/content/stacks/delivery.html)
- [Logging](https://playbook.stakater.com/content/stacks/logging.html)
- [Monitoring](https://playbook.stakater.com/content/stacks/monitoring.html)
- [Security](https://playbook.stakater.com/content/stacks/security.html)
- [Tracing](https://playbook.stakater.com/content/stacks/tracing.html)

## Platfrom Deployment

### Pre-Requisites

1. This Document expects that the user has familiarity with the following technologies: 

    1. Basic working understanding of Kubernetes and kubectl
    2. [Helm Charts](https://github.com/helm/charts#helm-charts)
    3. [Kubernetes Operators](https://coreos.com/operators/)
    4. [Helm Operator](https://playbook.stakater.com/content/processes/deployment/Helm-operator.html#the-helmrelease-custom-resource).
    5. [Flux](https://playbook.stakater.com/content/processes/gitops/gitops-with-flux.html#get-started-with-flux-helm).

2. *EKS*: Before deploying, user must have a `valid working domain` on Route53. e.g. (example.com, subdmain.example.com etc.) and AWS Credentials (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY) that has access to create Route53 entries.


### Pre-Pipeline Configuration
The sections contains steps that must be performed before running the pipeline:

1. Fork [StakaterPlatform](https://github.com/stakater/StakaterPlatform) repository in Github and import it in your Gitlab account.

It is recommended to fork it in a private repository as you have to add sensitive information in it.

2. Tools have been configured with default configurations. Which can be replaced based on the requirement. Secrets have base64 encoded data in it which is `NOT SECURE`, so it is recommeded to secure the secret either by using [SealedSecrets](https://playbook.stakater.com/content/workshop/sealed-secrets/introduction.html#overview) or any other method of your choice.

#### Mandatory Configurations

These configurations must be checked into the forked repository.

| Name                           | Required  |  Description          |    File Path    |
| :---------------------------------: | :-------: | :------------------:| :------------------------: |
| SSL certificate secret named as `tls-cert`  |    Yes    |   a TLS certificate secret for domain in `control` namespace | Place under folder `platform/control/` |
| STAKATER_PLATFORM_SSH_GIT_URL |    Yes    |   flux.yaml | URL of the forked repository (e.g. git@gitlab.com/stakater/stakaterplatform.git ). Used by `Flux` to maintain state |
| STAKATER_PLATFORM_BRANCH      |    Yes    |   flux.yaml  | Forked repository branch used by flux |

#### Pipeline Environment Varaibles

Following Environment variables should be configured in CI/CD Pipeline `Varaibles` in GitLab

| Variables                           | Required  |  File Path          |  Description         |
| :--------------------------------- | :-------: | :------------------|:------------------- |
| CLOUD_PROVIDER              |    Yes    |   None | Cloud provider name Default:`aws` (Supported values: `aws`). Configures Storage Classes  |
| KUBE_CONFIG   |    Yes    |   None | Base64 Encoded Kubernetes Cluster Config |
| STAKATER_PLATFORM_SSH_GIT_URL |    Yes    |   flux.yaml | URL of the forked repository (e.g. git@gitlab.com/stakater/stakaterplatform.git ). Used by `Flux` to maintain state |
| STAKATER_PLATFORM_BRANCH      |    Yes    |   flux.yaml  | Forked repository branch used by flux |
| USER_MAIL                |    Yes    |   None  | User email to commit back changes to branch STAKATER_PLATFORM_BRANCH in the STAKATER_PLATFORM_SSH_GIT_URL repository |
| USER_NAME                |    Yes    |   None  | User name to commit back changes to branch STAKATER_PLATFORM_BRANCH in the STAKATER_PLATFORM_SSH_GIT_URL repository |
| REPO_ACCESS_TOKEN           |    Yes    |  None | Access token to commit back changes |
| TARGET   |   Yes | None | Makefile Target (Targets: `deploy`, `destroy`) |
| BASE64_ENCODED_AWS_ACCESS_KEY_ID    | Yes      | platform/control/secret-aws-creds.yaml | AWS Access Key Id to create Route53 entries by external-dns tool |
| BASE64_ENCODED_AWS_SECRET_ACCESS_KEY   | Yes | platform/control/secret-aws-creds.yaml  | AWS Access Key Secret to create Route53 entries by external-dns tool |
| DOMAIN |     Yes | Multiple Instances in files under platform/ directory | Domain used by Stakater Platform tools (e.g. platform.com) |
| BASE64_ENCODED_IMC_CONFIG | Yes | platform/control/secret-imc-config.yaml | IngressMonitorController (IMC) config to automate ingress creation |
| BASE64_ENCODED_JENKINS_CFG | Yes   | platform/delivery/secret-jenkins-cfg.yaml | Encoded Docker cfg json file used by jenkins for CI/CD pipelines |
| KEYCLOAK_CLIENT_ID      | Yes | platform/delivery/jenkins.yaml | KeyCloak Client Id used by jenkins security realm for authenticating with KeyCloak |
| KEYCLOAK_CLIENT_SECRET  | Yes | platform/delivery/jenkins.yaml | KeyCloak Client Secret used by jenkins security realm for authenticating with KeyCloak |
| BASE64_ENCODED_SLACK_CHANNEL  | Yes | platform/delivery/secret-slack-hook.yaml | Slack Channel name to generate slack alerts (e.g. `#jenkins-alerts`) |
| BASE64_ENCODED_SLACK_WEBHOOK_URL | Yes | platform/delivery/secret-slack-hook.yaml | Slack Channel URL to generate slack alerts (e.g. `#https://hooks.slack.com/services/AAAAAAAAA/BBBBBBBBBBBBBB`) |
| BASE64_ENCODED_HUB_TOKEN  | Yes | platform/delivery/secret-jenkinshub-api-token.yaml | GitHub API token to post comments on PRs by Jenkins|
| BASE64_ENCODED_GITLAB_TOKEN  | Yes | platform/delivery/secret-jenkinshub-api-token.yaml | GitLab API token to post comments on PRs by Jenkins|
| BASE64_ENCODED_BITBUCKET_TOKEN | Yes | platform/delivery/secret-jenkinshub-api-token.yaml | BitBucket API token to post comments on PRs by Jenkins|
| BASE64_ENCODED_NEXUS_ADMIN_ACCOUNT_JSON | No | platform/delivery/nexus.yaml | Base64 nexus json for admin account. default value in plain text: <br>`{"name": "user-admin","type": "groovy","content": "security.addUser('user-admin', 'Stackator', 'Admin', 'user@gmail.com', true, 'stakater@qwerty786', ['nx-admin'])"}` <br>  |
| BASE64_ENCODED_NEXUS_CLUSTER_ACCOUNT_JSON | No | platform/delivery/nexus.yaml | Base64 nexus json for cluster account default value in plain text: <br>`{"name": "cluster-admin","type": "groovy","content": "security.addRole('cluster', 'cluster', 'User with privileges to allow read access to repo content and healtcheck', ['nx-healthcheck-read','nx-repository-view-docker-stackator-docker-browse','nx-repository-view-docker-stackator-docker-read','nx-search-read'],  ['nx-anonymous']); security.addUser('cluster-admin', 'Cluster', 'Cluster', 'user@gmail.com', true, 'stakater@qwerty786', ['cluster'])"}`<br> |
| NEXUS_ADMIN_ACCOUNT_USERNAME | No | platform/delivery/nexus.yaml | Admin Account username for Nexus. Default value:`user-admin` |
| NEXUS_CLUSTER_ACCOUNT_USERNAME | No | platform/delivery/nexus.yaml | Cluster account username for Nexus. Default value:`cluster-admin`|
| BASE64_ENCODED_ALERTMANAGER_CONFIG | Yes | platform/monitoring/secret-alertmanager-config.yaml | Base64 encoded Alertmanager config. |
| BASE64_ENCODED_KEYCLOAK_CONFIG | Yes | platform/security/secret-keycloak-config.yaml | Base64 encoded KeyCloak config. |
| BASE64_ENCODED_PROXYINJECTOR_CONFIG | Yes | platform/security/secret-pi-config.yaml | Base64 encoded ProxyInjector tool config to inject proxy for SSO with KeyCloak |

### Pipeline Execution

1. Once the above variables are configured, start GitLab pipeline for the forked repository 

2. The Pipline will deploy flux pod in flux namespace and output an ssh key which must be added to deploy keys in forked repo `with write access` to allow flux to initiate GitOps.

SSH is printed by flux in its logs. Logs can be seen using the command given below:

```bash
kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2
```

3. Once the key is added, all namespaces and tools will be deployed in the k8s cluster by flux. 

4. If configuration needs to be changed, change it locally and then commit the changes in the repository. Flux continously monitor the reposiotry and apply the changes on the cluster.
    Use tag `[skip ci]` in commit message to skip running CI pipeline for each commit.

### Stkater Platform Deployment Validation

Stakater Platform can be validated by using the following steps:

1. URL given below belongs to a web application that contins link to all the platform components. Open each application to verfiy whether it is working or not.

```bash
https://forecastle-control.DOMAIN.com
```

![forecastle image](./images/forecastle.png)

2. We will deploy [Nordmart](https://playbook.stakater.com/content/workshop/nordmart-intro.html#introduction) application using the guideline provided in this [link](https://playbook.stakater.com/content/workshop/nordmart-ci-cd.html#ci-cd-pipeline-creation)



    

    

## Compatibility Matrix

Stakater Platform has been tested on following environment:

| Platform Version| K8s Version  | Infrastructure |
|---|---|---|
| v0.0.1 | 1.14 | eks.6 |
