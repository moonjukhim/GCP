### AHYBRID022 North-south routing with Multi-Cluster Gateways


1. Configure kubectl and cluster

   ```bash
   gcloud container clusters update gke-west-1  --gateway-api=standard --region=${WEST1_LOCATION}
   ```

2. Register cluster in an Anthos Fleet

   ```bash
   gcloud container fleet memberships register gke-west-1 \
   --gke-cluster ${WEST1_LOCATION}/gke-west-1 \
   --enable-workload-identity \
   --project=${PROJECT_ID}

   # ...
   # register gke-west-2 & gke-east-1
   # ...

   gcloud container fleet memberships list --project=${PROJECT_ID}
   ```

3. Enable Multi-cluster Service(MCS)

   ```bash
   gcloud container fleet multi-cluster-services enable \
   --project ${PROJECT_ID}

    gcloud projects add-iam-policy-binding ${PROJECT_ID} \
      --member "serviceAccount:${PROJECT_ID}.svc.id.goog[gke-mcs/gke-mcs-importer]" \
      --role "roles/compute.networkViewer" \
      --project=${PROJECT_ID}
   
   gcloud container fleet multi-cluster-services describe --project=${PROJECT_ID}
   ```

4. Install Gateway API CRD & enable Multi-cluster Gateway

```bash
gcloud container fleet ingress enable \
  --config-membership=gke-west-1 \
  --project=${PROJECT_ID} \
  --location=us-west2

gcloud container fleet ingress describe --project=${PROJECT_ID}

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member "serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-multiclusteringress.iam.gserviceaccount.com" \
  --role "roles/container.admin" \
  --project=${PROJECT_ID}

kubectl get gatewayclasses --context=gke-west-1 
```

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
