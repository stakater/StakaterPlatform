.ONESHELL:
SHELL= /bin/bash

CLOUD_PROVIDER ?= aws
STAKATER_PLATFORM_SSH_GIT_URL ?= NULL
STAKATER_PLATFORM_BRANCH ?= master

ARGS:= $(STAKATER_PLATFORM_SSH_GIT_URL) $(STAKATER_PLATFORM_BRANCH)

setvars:
	bash setupvars.sh $(ARGS)
	kubectl apply -f storageclass/$(CLOUD_PROVIDER).yaml

deploy: setvars
	bash install.sh

destroy:
    bash destroy.sh

.PHONY: setvars deploy