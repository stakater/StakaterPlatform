NAMESPACES="nordmart-dev-apps nordmart-dev-tools"

# Delete all resources for nordmart
kubectl delete --ignore-not-found --wait=true -R -f platform/nordmart

# Delete namespaces
kubectl delete namespaces --force --grace-period=0 $NAMESPACES