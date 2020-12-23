# Creating Google Kubernetes Engine Deployments

## 1.배포 매니페스트 생성 및 배포

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone

git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Deployments/
```

매니페스트 파일 생성

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.7.9
        ports:
        - containerPort: 80
```

배포하기

```bash
kubectl apply -f ./nginx-deployment.yaml
kubectl get deployments
```

배포 확인

```bash
kubectl get deployments
```

## 2.수동으로 스케일업 & 다운

replica의 수를 조정하고 다시 확인

```bash
kubectl scale --replicas=1 deployment nginx-deployment
kubectl scale --replicas=3 deployment nginx-deployment
```


## 3.배포 롤아웃 및 배포 롤백

배포 롤아웃
처음에 nginx: nginx:1.7.9의 revision 1
나중에 nginx: nginx:1.9.1의 revision 2

```bash
kubectl set image deployment.v1.apps/nginx-deployment nginx=nginx:1.9.1 --record
```

롤아웃 상태 확인

```bash
kubectl rollout status deployment.v1.apps/nginx-deployment
```

롤아웃 이력 확인

```bash
kubectl rollout history deployment nginx-deployment
```

롤백 수행

```bash
kubectl rollout undo deployments nginx-deployment
kubectl rollout history deployment nginx-deployment
```

가장 최근에 배포된 리비전 정보 확인

```bash
kubectl rollout history deployment/nginx-deployment --revision=3
```

## 4.매니페스트에 서비스 타입 설정

service-nginx.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  type: LoadBalancer
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 60000
    targetPort: 80
```

배포

```
kubectl apply -f ./service-nginx.yaml
```

로드밸런서 상태 확인

```bash
kubectl get service nginx
```


## 5.카나리아 배포 수행

nginx-canary.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-canary
  labels:
    app: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        track: canary
        Version: 1.9.1
    spec:
      containers:
      - name: nginx
        image: nginx:1.9.1
        ports:
        - containerPort: 80
```

카나리아 배포

```bash
kubectl apply -f nginx-canary.yaml
kubectl get deployments
```

이전 배포했던 버전을 replica를 0으로 설정

```bash
kubectl scale --replicas=0 deployment nginx-deployment
kubectl get deployments
```

