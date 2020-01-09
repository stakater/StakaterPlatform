#!/bin/bash

CLOUD_PROVIDER=${1}
NAMESPACES="control delivery logging monitoring security tracing flux istio-system"
TLS_SECRET_FILE="platform/control/secrets/secret-tls-cert.yaml"

# Create Namespaces
for NAMESPACE in $NAMESPACES; do kubectl create namespace $NAMESPACE; done

# Configure RBAC 
kubectl create serviceaccount tiller --namespace kube-system
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

# Init Helm
helm init --wait --service-account tiller || true

# Install storage class
kubectl apply -f storageclass/$CLOUD_PROVIDER.yaml

# Install tls secret
kubectl apply -f $TLS_SECRET_FILE

# Add Fluxcd repo to helm repos
helm repo add fluxcd https://charts.fluxcd.io && helm repo update

# Install helm Operator
helm upgrade --version 0.2.0 -i --wait --force helm-operator fluxcd/helm-operator --namespace flux --set createCRD=true,serviceAccount.name=helm-operator,clusterRole.name=helm-operator

# Install Flux
kubectl apply -f platform/flux/secrets/secret-flux-key.yaml
kubectl apply -f platform/flux/flux.yaml

# Wait till all pods against flux deployment are deployed & then print flux public key
kubectl -n flux wait --timeout=200s --for condition=Ready pod -l release=stakater-infra-flux
echo -e "\n======== Add the following Flux Public Key to your git repository ========"
#kubectl -n flux logs deployment/flux | grep identity.pub | cut -d '"' -f2
cat ./configs/flux.pub