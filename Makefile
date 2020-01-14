# Use this Makefile if you want to setup/deploy/destroy StakaterPlatform from devstation(local workstation;laptop, computer etc.)

.ONESHELL:
SHELL= /bin/bash

include variables.config

configure: configure-repo commit

configure-repo:
	git checkout $(STAKATER_PLATFORM_BRANCH) 2>/dev/null || git checkout -b $(STAKATER_PLATFORM_BRANCH) && \
	yes | ssh-keygen -q -N "" -f ./configs/flux >/dev/null && \
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=SE/ST=StakaterUser/L=Stockholm/O=Stakater/CN=www.example.com" -keyout ./configs/sealed-secret-tls.key  -out ./configs/sealed-secret-tls.cert  2>/dev/null && \
	bash scripts/configure.sh

install-kubeseal:
	curl -o kubeseal -L https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.9.6/kubeseal-linux-amd64 && \
    install -m 755 kubeseal /usr/local/bin/kubeseal

commit:
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

deploy-nordmart-with-istio:
	make -f Makefile-nordmart deploy-nordmart-with-istio

deploy-nordmart-without-istio: 
	make -f Makefile-nordmart deploy-nordmart-without-istio

track-secrets:
	git update-index --no-skip-worktree variables.config && \
    git update-index --no-skip-worktree $(git ls-files | grep 'configs/')

un-track-secrets:
	git update-index --skip-worktree variables.config && \
    git update-index --skip-worktree $(git ls-files | grep 'configs/')

.PHONY: configure deploy verify destroy