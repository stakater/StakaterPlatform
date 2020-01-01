#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing"

# Delete all HRs
for NAMESPACE in $NAMESPACES; do
  kubectl delete hr --all -n $NAMESPACE
done

# Remove any remaing platform resources
kubectl delete -f platform/

# Remove Tiller
helm reset --force

# Remove Helm Operator
helm delete --purge helm-operator

#TODO remove role and cluster roles

# Delete all namespaces
kubectl delete namespaces $NAMESPACES