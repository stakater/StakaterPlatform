# StakaterPlatform

## Problem Statement

How can a novice user deploy tools that are required for the management of kubernetes cluster?

## Solution

Kick-start your kubernetes cluster with Stakater Platform. A consolidated solution for logging, tracing, monitoring, delivery, security and much more. 
For detailed walk-through please visit [StakaterPlatform](https://playbook.stakater.com/content/stacks/stakaterplatform.html)

StakaterPlatform consist of 6 stacks:
- [Control](https://playbook.stakater.com/content/stacks/control.html)
- [Delivery](https://playbook.stakater.com/content/stacks/delivery.html)
- [Logging](https://playbook.stakater.com/content/stacks/logging.html)
- [Monitoring](https://playbook.stakater.com/content/stacks/monitoring.html)
- [Security](https://playbook.stakater.com/content/stacks/security.html)
- [Alerting](https://playbook.stakater.com/content/stacks/alerting.html)
- [Tracing](https://playbook.stakater.com/content/stacks/tracing.html)


## Prerequisites

- Kubernetes cluster with at least 8 VCPUS & 32 GB of RAM
- kubectl (between v1.11 & v1.15.3)
- helm (v2.15.0 or lower)
- A working domain (e.g. `stakaterplatform.com` ) 
- SSL Certificate for that domain

## Installation

1. [Duplicate](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository#mirroring-a-repository) this [repository](https://github.com/stakater/stakaterplatform).
2. Update [configuration variables](#Basic-Configuration) in `variables.config` file and provide the relevant values.
3. [Recommended but optional] To take full advantage of the tool stack configure [Additional Variables](docs/detailed-config.md) as well.
4. [Add the public SSH key](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account) from `configs/flux.pub` to your Git repository with **write access**.
5. Ensure that correct context is set for kubectl & helm.
6. run `make configure`, this will make all required substitutions based on configuration variables in the repository. When prompted commit those changes.
7. Once changes are committed, run `make deploy` this will deploy StakaterPlatform on your cluster(Estimated time: 5-10 minutes). :confetti_ball: :confetti_ball:

**Note:** Since `variables.config` file and `configs/` directory contains private information those files are not being
 tracked in git and won't/shouldn't be committed. In case you wan't to commit those changes run `make track-secrets`.

## Verify

Run `make verify` to run tests to ensure that all the relevant endpoints are up and running.

## Basic Configuration
| Variables | Description | Default |  
|---|---|---|
| CLOUD_PROVIDER | Name of the k8s cloud provider | `nil` <br> (`aws` \| `azure`) |
| DNS_PROVIDER | Cloud DNS Provider | `aws` (Route53) |
| EXTERNAL_DNS_AWS_ACCESS_KEY_ID | AWS Access Key Id | `nil` |
| EXTERNAL_DNS_AWS_SECRET_ACCESS_KEY | AWS Secret Access Key | `nil` |
| DOMAIN | Domain to use for StakaterPlatform | `nil` |
| BASE64_ENCODED_SSL_CERTIFICATE_CA_CRT | Base64 encoded Intermediate Certificate value | `nil` |
| BASE64_ENCODED_SSL_CERTIFICATE_TLS_CRT | Base64 encoded Server Certificate value |`nil` |
| BASE64_ENCODED_SSL_CERTIFICATE_TLS_KEY | Base64 encoded Certificate Key value |`nil` |
| STAKATER_PLATFORM_SSH_GIT_URL | SSH URL for your Github repo. | `nil`<br>(e.g `git@github.com/stakater/StakaterPlatform.git`. Notice `:` is replaced with `/` in the URL ) |
| STAKATER_PLATFORM_BRANCH | Branch to use for `STAKATER_PLATFORM_SSH_GIT_URL` | `master` |

## Detailed Configuration

See [Detailed Configurations](docs/detailed-config.md) for configuring available tools in the stacks. 

## Uninstall

Run `make destroy` to remove StakaterPlatform from your cluster.

## Production Configuration and Hardening

- Change default user-names and passwords for all tools (`variables.config`)
- Add your own SSH keys for flux
- Use Identity Providers (e.g. Google, Active Directory etc.) and configure keyclaok to use that

## Compatibility Matrix

StakaterPlatform has been tested on following kubernetes flavors:

| Platform Version| K8s Version  | Infrastructure |
|---|---|---|
| v0.0.1 | 1.14 | eks.6 |
| v0.0.1 | 1.14.8 | aks |


## Community

If you have questions, check the [Documentation](https://playbook.stakater.com/content/stacks/stakaterplatform.html) and
 talk to us on slack [#community on Stakater Slack](https://stakater.slack.com/messages/community).
 
Click [here](https://slack-inviter.stakater.com) to join [Stakater](https://stakater.com) on Slack.
