
```bash
export PROJECT_ID=$(gcloud config get-value project)
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-central1-b

gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $CLUSTER_ZONE --project $PROJECT_ID

gcloud container clusters list

```

```bash
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_1.9 > install_asm
chmod +x install_asm
./install_asm \
--project_id $PROJECT_ID \
--cluster_name $CLUSTER_NAME \
--cluster_location $CLUSTER_ZONE \
--mode install \
--enable_gcp_apis \
--enable_all
kubectl get pod -n istio-system

kubectl -n istio-system get pods -l app=istiod --show-labels
```

