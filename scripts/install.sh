#!/bin/bash

CLOUD_PROVIDER=${1}
NAMESPACES="control delivery logging monitoring security flux istio-system"
TLS_SECRET_FILE="platform/control/secrets/secret-tls-cert.yaml"

# Create Namespaces
for NAMESPACE in $NAMESPACES; do kubectl create namespace $NAMESPACE; done

# Configure RBAC 
kubectl apply -f tiller-rbac.yaml

# Init Helm
helm init --wait --service-account tiller || true

# Install storage class
kubectl apply -f storageclass/$CLOUD_PROVIDER.yaml

# Add Fluxcd repo to helm repos
helm repo add fluxcd https://charts.fluxcd.io && helm repo update

# Install block storage incase of IBM
if [[ $CLOUD_PROVIDER == "ibm" ]];
then
  helm repo add ibm  https://registry.bluemix.net/helm/ibm && \
  helm repo update && \
  helm upgrade -i --wait --force ibmc-block-storage ibm/ibmcloud-block-storage-plugin --namespace kube-system
fi

# Install helm Operator
helm upgrade --version 0.2.0 -i --wait --force helm-operator fluxcd/helm-operator --namespace flux --set createCRD=true,serviceAccount.name=helm-operator,clusterRole.name=helm-operator

# Install SealedSecrets
kubectl apply -f configs/secret-sealed-secret-tls-cert.yaml
kubectl apply -f platform/crds/crd-sealed-secrets.yaml
kubectl apply -f platform/security/sealed-secrets.yaml
until [[ "$(helm status stakater-security-sealed-secrets -ojson | jq .info.status.code)" == "1" ]]; do echo waiting for deployment to complete... ; done

# Install tls secret
kubectl apply -f $TLS_SECRET_FILE

# Install dashboard
kubectl apply -f platform/control/kubernetes-dashboard.yaml
until [[ "$(helm status stakater-control-dashboard -ojson | jq .info.status.code)" == "1" ]]; do echo waiting for deployment to complete... ; done
echo -e "\n========= Kubernetes Dashboard Access Token =========="
kubectl -n control describe secret $(kubectl -n control get secret | grep stakater-control-dashboard-kubernetes-dashboard-token | awk '{print $1}') | grep 'token:' | awk '{print $2}'

# Install Flux
kubectl apply -f platform/flux/secrets/secret-flux-key.yaml
kubectl apply -f platform/flux/flux.yaml
echo -e "\n======== Add the following Flux Public Key to your git repository ========"
#kubectl -n flux logs deployment/stakater-infra-flux | grep identity.pub | cut -d '"' -f2
cat ./configs/flux.pub

n=0
until [ $n -ge 5 ]
do
   kubectl apply -R -f platform/ && break
   n=$[$n+1]
   echo "Retrying for $n/5 times..."
done