1. Configure kubectl and cluster

```bash

```

2. Register cluster in an Anthos Fleet

   ```bash
   gcloud container fleet memberships register gke-west-1 \
   --gke-cluster ${WEST1_LOCATION}/gke-west-1 \
   --enable-workload-identity \
   --project=${PROJECT_ID}

   # ...

   gcloud container fleet memberships list --project=${PROJECT_ID}
   ```

3. Enable Multi-cluster Service(MCS)

   ```bash
   gcloud container fleet multi-cluster-services enable \
   --project ${PROJECT_ID}
   ```

4. Install Gateway API CRD & enable Multi-cluster Gateway
5. Deploy the demo app

   - create Deployment and Namespace
   - create Service and ServiceExports

6. Task 6. Deploy the Gateway and HTTPRoutes

##### 대문자 Gateway로 바꿔서 실행해야 함!

```bash
# kubectl get gateway external-http -o=jsonpath="{.status.addresses[0].value}" --context gke-west-1 --namespace store | xargs echo -e
kubectl get Gateway --namespace store
kubectl get Gateway external-http -o=jsonpath="{.status.addresses[0].value}" --context gke-west-1 --namespace store | xargs echo -e

kubectl describe Gateway.gateway.networking.k8s.io -n store
kubectl get Gateway.gateway.networking.k8s.io -n store
```

---

[Network endpoint groups overview](https://cloud.google.com/load-balancing/docs/negs)

34.54.137.180