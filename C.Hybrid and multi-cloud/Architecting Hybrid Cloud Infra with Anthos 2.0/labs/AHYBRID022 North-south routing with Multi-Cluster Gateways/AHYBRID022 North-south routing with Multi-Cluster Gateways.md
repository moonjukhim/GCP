### Error Reporting

ERROR: (gcloud.container.fleet.ingress.enable) INVALID_ARGUMENT: InvalidValueError for field config_membership: Membership "projects/qwiklabs-gcp-01-efa77e845415/locations/global/memberships/gke-west-1" does not exist

```bash
kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.5.0" \
| kubectl apply -f - --context=gke-west-1
# github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.5.0
# https://github.com/kubernetes-sigs/gateway-api/tree/main/config/crd/standard

```

customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
