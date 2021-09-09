1. GKE 클러스터 생성

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
gcloud container clusters create $my_cluster --num-nodes 3 --zone $my_zone --enable-ip-alias
```

2. 클러스터에 연결

```bash
gcloud container clusters get-credentials $my_cluster --zone $my_zone
```

3. 파드 배포하기

```bash
kubectl create deployment --image nginx nginx-1
kubectl get pods
```