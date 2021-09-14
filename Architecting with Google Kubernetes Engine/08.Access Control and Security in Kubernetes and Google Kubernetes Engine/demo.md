
1. enable Workload Identity 

```bash
gcloud container clusters update cluster-1 \
  --workload-pool=fluent-optics-321005.svc.id.goog \
  --zone us-central1-c

# gcloud container clusters update [CLUSTER-NAME] \
#   --workload-pool=[PROJECT ID].svc.id.goog \
#   --zone us-central1-c
```

2. Kubernetes Service Account 생성

gke-access-gcs.ksa.yaml 파일
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gke-access-gcs
```

```bash
kubectl apply -f gke-access-gcs.ksa.yaml
```

3. KSA와 GSA 연결

```bash
gcloud iam service-accounts add-iam-policy-binding \
  --role roles/iam.workloadIdentityUser \
  --member "serviceAccount:fluent-optics-321005.svc.id.goog[default/gke-access-gcs]" \
  gcp-gsa@fluent-optics-321005.iam.gserviceaccount.com

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