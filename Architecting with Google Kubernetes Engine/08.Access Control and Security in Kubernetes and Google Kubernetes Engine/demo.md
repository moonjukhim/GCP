0. Google Service Account 생성

```bash

```

1. enable Workload Identity 

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
export PROJECT_ID=$(gcloud config get-value core/project) 
# gcloud container clusters create $my_cluster --num-nodes 3 --zone $my_zone

gcloud container clusters update ${my_cluster} \
  --workload-pool=${PROJECT_ID}.svc.id.goog \
  --zone ${my_zone}
```

2. Kubernetes Service Account 생성

```bash
cat <<'EOF' >> gke-access-gcs.ksa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gke-access-gcs
EOF
kubectl apply -f gke-access-gcs.ksa.yaml
```

3. KSA와 GSA 연결

```bash
export KSA="gke-access-gcs"
export GSA="gcp-gsa"
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:${PROJECT_ID}.svc.id.goog[default/${KSA}]" \
  ${GSA}@${PROJECT_ID}.iam.gserviceaccount.com

# gcloud iam service-accounts add-iam-policy-binding \
#   --role roles/iam.workloadIdentityUser \
#   --member "serviceAccount:[PROJECT ID].svc.id.goog[NAMESPACE/KSA-NAME]" \
#   gcp-gsa@[PROJECT ID].iam.gserviceaccount.com
```

4. KSA와 GSA 어노테이션 설정

```bash
kubectl annotate serviceaccount \
  --namespace default \
   gke-access-gcs \
   iam.gke.io/gcp-service-account=gcp-gsa@fluent-optics-321005.iam.gserviceaccount.com

# kubectl annotate serviceaccount \
#   --namespace default \
#    gke-access-gcs \
#    iam.gke.io/gcp-service-account=gcp-gsa@[PROJECT ID].iam.gserviceaccount.com   
```

5. 읽기/쓰기 권한 설정

```bash
gcloud projects add-iam-policy-binding fluent-optics-321005 \
--member=serviceAccount:gcp-gsa@fluent-optics-321005.iam.gserviceaccount.com \
--role=roles/storage.objectAdmin
```

6. 테스트

```bash
kubectl run -it \
  --image google/cloud-sdk:slim \
  --serviceaccount gke-access-gcs \
  --namespace default \
  workload-identity-test
```

7. 컨테이너에서 수행

```bash
gsutil ls
```