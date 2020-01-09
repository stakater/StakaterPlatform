#!/bin/bash
NAMESPACES="flux control delivery logging monitoring security tracing istio-system"

# Delete flux to stop GitOps
kubectl delete --wait=true -R -f platform/flux/

# Remove everything from Platform
kubectl delete -R -f platform/

# Delete all namespaces
kubectl delete namespaces $NAMESPACES

# Remove StorageClass
kubectl delete -R -f storageclass/ 2>/dev/null

# Remove Helm Operator
helm delete --purge helm-operator

# Remove Tiller
helm reset --force

# Delete tiller RBAC
kubectl delete -f tiller-rbac.yaml