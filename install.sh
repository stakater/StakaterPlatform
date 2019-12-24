set -x
#!/bin/bash
FLUXNAMESPACE="flux"
NAMESPACES="control delivery logging monitoring security tracing "$FLUXNAMESPACE

# Create Namespaces
for NAMESPACE in $NAMESPACES; do kubectl create namespace $NAMESPACE; done

# Configure RBAC and Init Helm
kubectl apply -f rbac.yaml
helm init --wait --service-account tiller || true

# Add Fluxcd repo to helm repos
helm repo add fluxcd https://charts.fluxcd.io && helm repo update

# Install helm Operator
helm upgrade --version 0.2.0 -i --wait --force helm-operator fluxcd/helm-operator --namespace $FLUXNAMESPACE --set createCRD=true,serviceAccount.name=helm-operator,clusterRole.name=helm-operator

# Install Flux
kubectl apply -f flux.yaml -n $FLUXNAMESPACE