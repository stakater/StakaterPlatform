set -x
#!/bin/bash

source ../configs/variables.config

NAMESPACES="control delivery logging monitoring security tracing flux"
TLS_SECRET_FILE="../platform/control/secrets/secret-tls-cert.yaml"

# Create Namespaces
for NAMESPACE in $NAMESPACES; do kubectl create namespace $NAMESPACE; done

# Configure RBAC and Init Helm
kubectl apply -f ../platform/rbac.yaml
helm init --wait --service-account tiller || true

# TODO install sealed-secrets and convert all secrets!

# Install storage class
kubectl apply -f storageclass/$(CLOUD_PROVIDER).yaml

# Install tls secret
kubectl apply -f $TLS_SECRET_FILE

# Add Fluxcd repo to helm repos
helm repo add fluxcd https://charts.fluxcd.io && helm repo update

# Install helm Operator
helm upgrade --version 0.2.0 -i --wait --force helm-operator fluxcd/helm-operator --namespace flux --set createCRD=true,serviceAccount.name=helm-operator,clusterRole.name=helm-operator

# Install Flux
kubectl apply -f ../platform/flux.yaml -n flux

# Wait till all pods against flux deployment are deployed & then print flux public key
kubectl -n flux wait --timeout=200s --for condition=ready pod -l release=flux
echo -e "\n========= Add the following Public key of flux to your repo with read write access: ==========\n"
kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2

# Wait for dashboard to be ready & then print dashboard access token
kubectl -n control wait --timeout=200s --for condition=ready pod -l release=stakater-control-dashboard
echo -e "\n========= Kubernetes Dashboard Access Token ==========\n"
kubectl -n control describe secret $(kubectl -n control get secret | grep stakater-control-dashboard-kubernetes-dashboard-token | awk '{print $1}') | grep 'token:' | cut -d ':' -f2