set +x
#!/bin/bash
NAMESPACES="control delivery logging monitoring security tracing flux"

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