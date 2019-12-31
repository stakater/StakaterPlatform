# StakaterPlatform

StakaterPlatform provides out of the box stacks to control, monitor, log, trace and security for applications deployed on kubernetes.

StakaterPlatform consist of 6 stacks
- [Control](https://playbook.stakater.com/content/stacks/control.html)
- [Delivery](https://playbook.stakater.com/content/stacks/delivery.html)
- [Logging](https://playbook.stakater.com/content/stacks/logging.html)
- [Monitoring](https://playbook.stakater.com/content/stacks/monitoring.html)
- [Security](https://playbook.stakater.com/content/stacks/security.html)
- [Tracing](https://playbook.stakater.com/content/stacks/tracing.html)


### Kubernetes Cluster Requitements

The Minimum collective resources of the Kubernetes cluster should be:
- Kubernetes version >=1.11
- Total CPUs >= 4
- Total Memory >= 32 GB

## Prerequistes

- A working domain (e.g. `stakaterplatform.com` ) 
- SSL Certificate for domain
- kubectl >= 1.11
- Helm == 2.11

## Installation

- Fork this repository in Github and clone it locally.
- Update [variables](#Configuration) in `variables.config`
- Configure Variables:
```
make -f Makefile-dev configure
```
- Deploy:
```
make -f Makefile-dev deploy
```
<!-- TODO: Flux key addition documentation -->

## Basic Configuration
| Variables | Description | Default |  
|---|---|---|
| CLOUD_PROVIDER | Name of the k8s cloud provider | `nil` <br> (`aws` \| `azure`) |
| DNS_PROVIDER | Cloud DNS Provider | `aws` (Route53) |
| EXTERNAL_DNS_AWS_ACCESS_KEY_ID | AWS Access Key Id | `nil` |
| EXTERNAL_DNS_AWS_SECRET_ACCESS_KEY | AWS Secret Access Key | `nil` |
| DOMAIN | Domain to expose StakaterPlatform | `nil` |
| BASE64_ENCODED_SSL_CERTIFICATE_CA_CRT | Base64 encoded Intermediate Certificate value | `nil` |
| BASE64_ENCODED_SSL_CERTIFICATE_TLS_CRT | Base64 encoded Server Certficate value |`nil` |
| BASE64_ENCODED_SSL_CERTIFICATE_TLS_KEY | Base64 encoded Certificate Key value |`nil` |
| STAKATER_PLATFORM_SSH_GIT_URL | SSH URL for your Github repo. | `nil`<br>(e.g `git@github.com/stakater/StakaterPlatform.git`. Notice `:` is replaced with `/` in the URL ) |
| STAKATER_PLATFORM_BRANCH | Branch to use for `STAKATER_PLATFORM_SSH_GIT_URL` | `master` |

## Detailed Configuration

See [Detailed Configurations](docs/detailed-config.md) for configuring available tools in the stacks. 


## Uninstall

Run the following to tear down StakaterPlatform
```
make -f Makefile-dev destroy
```

## Compatibility Matrix

StakaterPlatform has been tested on following kubernetes flavors:

| Platform Version| K8s Version  | Infrastructure |
|---|---|---|
| v0.0.1 | 1.14 | eks.6 |
