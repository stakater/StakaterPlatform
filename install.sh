#!/bin/bash
FLUXNAMESPACE="flux"
NAMESPACES="control delivery logging monitoring security tracing "$FLUXNAMESPACE

# Create Namespaces
for NAMESPACE in $NAMESPACES; do kubectl create namespace $NAMESPACE; done

# Configure RBAC and Init Helm
kubectl apply -f rbac.yaml
helm init --service-account tiller || true

# Add Fluxcd repo to helm repos
helm repo add fluxcd https://charts.fluxcd.io
helm repo update

# Install helm Operator
helm upgrade -i --force helm-operator fluxcd/helm-operator --namespace $FLUXNAMESPACE --set createCRD=true,serviceAccount.name=helm-operator,clusterRole.name=helm-operator

# Install Flux
kubectl apply -f flux.yaml -n $FLUXNAMESPACE