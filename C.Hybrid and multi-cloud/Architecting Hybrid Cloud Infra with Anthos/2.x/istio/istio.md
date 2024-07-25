[Getting Started](https://istio.io/latest/docs/setup/getting-started/#download)

1. Download Istio

```bash
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.22.3
export PATH=$PWD/bin:$PATH
```

2. Install Istio

```bash
istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled
```

3. Deploy sample app

```bash
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl get services
kubectl get pods
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"
```

4. Open in-bound traffic

```bash
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
istioctl analyze
```

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
    - port:
        number: 8080
        name: http
        protocol: HTTP
      hosts:
        - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo
spec:
  hosts:
    - "*"
  gateways:
    - bookinfo-gateway
  http:
    - match:
        - uri:
            exact: /productpage
        - uri:
            prefix: /static
        - uri:
            exact: /login
        - uri:
            exact: /logout
        - uri:
            prefix: /api/v1/products
      route:
        - destination:
            host: productpage
            port:
              number: 9080
```

5. View dashboard

```bash
kubectl apply -f samples/addons
kubectl rollout status deployment/kiali -n istio-system
istioctl dashboard kiali
```
