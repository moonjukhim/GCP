# Deploying to Google Kubernetes Engine with Helm

---

# 1.Helm 사용

GKE 클러스터에 접속

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone
```

Helm 바이너리 다운로드와 Helm 차트 배포

```bash
curl -LO https://git.io/get_helm.sh
```

```
chmod 700 get_helm.sh
./get_helm.sh
```

사용자 계정이 cluster-admin 역할을 가지고 있는지 확인

```
kubectl create clusterrolebinding user-admin-binding \
   --clusterrole=cluster-admin \
   --user=$(gcloud config get-value account)

kubectl create serviceaccount tiller --namespace kube-system
```