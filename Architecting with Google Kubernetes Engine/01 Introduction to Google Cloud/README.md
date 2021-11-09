1. 쿠버네티스 클러스터 생성

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

gcloud container clusters create $my_cluster --num-nodes 3 --zone $my_zone --enable-ip-alias
```

2. 쿠버네티스 클러스터 연결

```bash
gcloud container clusters get-credentials $my_cluster --zone $my_zone
nano ~/.kube/config
```

3. 클러스터 정보 확인

```bash
kubectl config view
kubectl cluster-info
kubectl config current-context
kubectl config use-context gke_${GOOGLE_CLOUD_PROJECT}_us-central1-a_standard-cluster-1
```
