```bash
kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.5.0" \
| kubectl apply -f - --context=gke-west-1
# github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.5.0
# https://github.com/kubernetes-sigs/gateway-api/tree/main/config/crd/standard

```


customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
