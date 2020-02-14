#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security istio-system"

# Delete Flux So it doesn't re-create helmReleases
kubectl delete --ignore-not-found --wait=true -R -f platform/flux/

# Delete Istio Operator and Istio Deployment
kubectl -n istio-system get IstioControlPlane stakater-istiocontrolplane -o=json | jq '.metadata.finalizers = null' | kubectl delete -f -

# Delete StakaterPlatform resources
kubectl delete --ignore-not-found --wait=true -R -f platform/

# Remove HelmOperator 
helm delete --purge helm-operator

# Remove StorageClass
kubectl delete --ignore-not-found -f storageclass/

# Delete NAMESPACES
kubectl delete namespaces --force --grace-period=0 $NAMESPACES

# Delete helm CRD
kubectl delete crd helmreleases.helm.fluxcd.io 

# Delete tiller
helm reset --force
# Manually deleting tiller pod . Bug in Helm 2.11 See: https://github.com/helm/helm/issues/4825
kubectl delete deploy $(kubectl get deploy -n kube-system | grep tiller-deploy | awk '{print $1}') -n kube-system

# Delete tiller RBAC
kubectl delete -f tiller-rbac.yaml 