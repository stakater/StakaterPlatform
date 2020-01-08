# Use this Makefile if you want to setup/deploy/destroy StakaterPlatform from devstation(local workstation;laptop, computer etc.)

.ONESHELL:
SHELL= /bin/bash

include variables.config

configure:
	git checkout $(STAKATER_PLATFORM_BRANCH) 2>/dev/null || git checkout -b $(STAKATER_PLATFORM_BRANCH) && \
	yes | ssh-keygen -q -N "" -f ./configs/flux >/dev/null && \
	bash scripts/configure.sh && \
	# TODO add pre-commit hook for skipping these files
	git update-index --skip-worktree variables.config && \
	git update-index --skip-worktree $(git ls-files | grep 'configs/') && \
	git add . && \
	git commit -a -m "[skip ci] update vars for deployment"  && \
	git push -u origin $(STAKATER_PLATFORM_BRANCH) || true

deploy:
	bash scripts/install.sh $(CLOUD_PROVIDER)

deploy-without-flux:
	kubectl apply -f platform/

pipeline-deploy: configure deploy

verify:
	for file in ./scripts/tests/* ; do \
		$${file};	
	done

destroy:
	bash scripts/destroy.sh

track-secrets:
	git update-index --no-skip-worktree variables.config && \
    git update-index --no-skip-worktree $(git ls-files | grep 'configs/')

un-track-secrets:
	git update-index --skip-worktree variables.config && \
    git update-index --skip-worktree $(git ls-files | grep 'configs/')

.PHONY: configure deploy verify destroy