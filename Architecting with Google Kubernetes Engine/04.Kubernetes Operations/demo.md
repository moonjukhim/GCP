1. Deploying GKE Clusters from Cloud Shell

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
gcloud container clusters create $my_cluster --num-nodes 3 --zone $my_zone --enable-ip-alias
```

2. Connect to GKE

```bash
gcloud container clusters get-credentials $my_cluster --zone $my_zone
```

---

```bash
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
```