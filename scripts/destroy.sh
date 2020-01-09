#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security istio-system"

# Avoid Deadlock for custom resources to wait for finalizers See: https://github.com/kubernetes/kubernetes/issues/60538
kubectl delete crd/istiocontrolplanes.install.istio.io & kubectl patch crd/istiocontrolplanes.install.istio.io -p '{"metadata":{"finalizers":[]}}' --type=merge
kubectl delete istiocontrolplanes/stakater-istiocontrolplane -n kube-system & kubectl patch istiocontrolplanes/stakater-istiocontrolplane -p '{"metadata":{"finalizers":[]}}' --type=merge -n istio-system

# Delete Flux So it doesn't re-create helmReleases
kubectl delete --ignore-not-found --wait=true -R -f platform/flux/

# Delete StakaterPlatform resources
kubectl delete --ignore-not-found --wait=true -R -f platform/

# Delete Helm Operator + HelmRelease history
helm delete --purge $(helm list --short)

# Remove namespaced resources from NAMESPACES (namespace scoped)
for NAMESPACE in $NAMESPACES; do
  kubectl delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all -n $NAMESPACE
done

# Manually delete Istio clusterroles /clusterrolebindings
kubectl delete clusterroles $(kubectl get clusterroles -l release=istio | grep -v NAME | awk '{print $1}')
kubectl delete clusterrolebindings $(kubectl get clusterrolebindings -l release=istio | grep -v NAME | awk '{print $1}')

## Delete CRDs
# Istio
kubectl delete crd $(kubectl get crds | grep istio | awk '{print $1}')
# Helm Operator
kubectl delete crd $(kubectl get crds | grep helmreleases.helm.fluxcd.io | awk '{print $1}')
# PodMonitors (Prometheus Operator)
kubectl delete crd $(kubectl get crds | grep podmonitors.monitoring.coreos.com | awk '{print $1}')

# Delete NAMESPACES
kubectl delete namespaces $NAMESPACES

# Delete tiller
helm reset --force
# Manually deleting tiller pod . Bug in Helm 2.11 See: https://github.com/helm/helm/issues/4825
kubectl delete pod -n kube-system $(kubectl get pods -n kube-system | grep tiller | awk '{print $1}')

kubectl delete serviceaccount tiller --namespace kube-system
kubectl delete clusterrolebinding tiller