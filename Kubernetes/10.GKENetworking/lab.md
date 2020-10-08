
두번째 클러스터 생성
```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
source <(kubectl completion bash)

gcloud container clusters create $my_cluster --num-nodes 3 --enable-ip-alias --zone $my_zone --enable-network-policy

gcloud container clusters get-credentials $my_cluster --zone $my_zone
```

단순한 웹 서버 애플리케이션 배포

```
kubectl create deployment hello-web --labels app=hello \
  --image=gcr.io/google-samples/hello-app:1.0 --port 8080 --expose
```

