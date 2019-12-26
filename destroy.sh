set -x
#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing"

kubectl delete hr infra-flux -n flux

# Create Namespaces
for NAMESPACE in $NAMESPACES; do 
  kubectl delete all --all -n $NAMESPACE && \
  kubectl delete configmap --all -n $NAMESPACE && \
  kubectl delete secrets --all -n $NAMESPACE && \
  kubectl delete ingress --all -n $NAMESPACE && \
  kubectl delete hr --all -n $NAMESPACE && \
  kubectl delete service --all -n $NAMESPACE && \
  kubectl delete pvc --all -n $NAMESPACE
done
helm reset --force
helm delete --purge helm-operator && kubectl delete crd helmreleases.helm.fluxcd.io -n flux
kubectl delete configmap -l OWNER=TILLER -n kube-system
kubectl delete namespaces $NAMESPACES