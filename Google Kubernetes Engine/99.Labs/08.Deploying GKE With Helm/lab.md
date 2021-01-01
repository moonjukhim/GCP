# Deploying to Google Kubernetes Engine with Helm

---

## Task1. Helm 차트를 사용하여 Kubernetes Engine에 솔루션 배포

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
chmod 700 get_helm.sh
./get_helm.sh
```

사용자 계정이 cluster-admin 역할을 가지고 있는지 확인

```
kubectl create clusterrolebinding user-admin-binding \
   --clusterrole=cluster-admin \
   --user=$(gcloud config get-value account)

kubectl create serviceaccount tiller --namespace kube-system

kubectl create clusterrolebinding tiller-admin-binding \
   --clusterrole=cluster-admin \
   --serviceaccount=kube-system:tiller

helm init --service-account=tiller
```

Helm 저장소 업데이트

```
helm repo update
helm version
```

Redis 서비스 생성

```bash
helm install stable/redis
```

Helm 차트는 구성 가능한 매개 변수와 함께 리소스 구성 파일의 패키지입니다. 


## Task2. Helm을 사용하여 배포된 솔루션 유효성 검사 및 테스트

kubectl을 사용하여 Helm을 통해 배포 된 Kubernetes 리소스 검사

```bash
kubectl get services
```

Kubernetes StatefulSet는 Pod 집합의 배포 및 확장을 관리하고 이러한 Pod의 순서 및 고유성을 보장합니다. Cloud Shell에서 다음 명령어를 실행하여 Helm 차트를 통해 배포 된 StatefulSet를 확인합니다.

```bash
kubectl get statefulsets
```

Kubernetes ConfigMap을 사용하면 구성 아티팩트를 저장하고 관리 할 수 ​​있으므로 컨테이너 이미지 콘텐츠에서 분리됩니다. 

```bash
kubectl get configmaps
```

secrets

```bash
kubectl get secrets
```

Helm 차트 검사

```bash
helm inspect stable/redis
helm install stable/redis --dry-run --debug
```

Redis 기능 테스트

```bash
export REDIS_IP=$(kubectl get services -l app=redis -o json | jq -r '.items[].spec | select(.selector.role=="master")' | jq -r '.clusterIP')

export REDIS_PW=$(kubectl get secret -l app=redis -o jsonpath="{.items[0].data.redis-password}"  | base64 --decode)

echo Redis Cluster Address : $REDIS_IP
echo Redis auth password   : $REDIS_PW

kubectl run redis-test --rm --tty -i --restart='Never' \
    --env REDIS_PW=$REDIS_PW \
    --env REDIS_IP=$REDIS_IP \
    --image docker.io/bitnami/redis:4.0.12 -- bash

redis-cli -h $REDIS_IP -a $REDIS_PW
```

redis 사용

```redis
set mykey this_amazing_value
get mykey
```