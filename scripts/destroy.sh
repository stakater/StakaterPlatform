#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing"

# Remove Helm Operator
helm delete --purge helm-operator

# Remove Tiller
helm reset --force

# Delete all HRs
for NAMESPACE in $NAMESPACES; do
  kubectl delete hr --all -n $NAMESPACE
done

# Remove any remaing platform resources
kubectl delete -f platform/

#TODO remove role and cluster roles

# Delete all namespaces
kubectl delete namespaces $NAMESPACES