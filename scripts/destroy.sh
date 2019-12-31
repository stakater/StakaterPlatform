set -x
#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing"

# Delete All HRs
for NAMESPACE in $NAMESPACES; do 
  kubectl delete hr --all -n $NAMESPACE
done

helm reset --force
helm delete --purge helm-operator
kubectl delete crd helmreleases.helm.fluxcd.io
kubectl delete configmap -l OWNER=TILLER -n kube-system
kubectl delete namespaces $NAMESPACES