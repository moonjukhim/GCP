# Deploying Google Kubernetes Engine

## Task1. Deploy GKE clusters

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
source <(kubectl completion bash)
gcloud container clusters get-credentials $my_cluster --zone $my_zone
```

## Task2. GKE 클러스터 수정

## Task3. 샘플 워크로드 배포

Configuration YAML

```yaml
apiVersion: "apps/v1"
kind: "Deployment"
metadata:
  name: "nginx-1"
  namespace: "default"
  labels:
    app: "nginx-1"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: "nginx-1"
  template:
    metadata:
      labels:
        app: "nginx-1"
    spec:
      containers:
      - name: "nginx-1"
        image: "nginx:latest"
---
apiVersion: "autoscaling/v2beta1"
kind: "HorizontalPodAutoscaler"
metadata:
  name: "nginx-1-hpa-wemj"
  namespace: "default"
  labels:
    app: "nginx-1"
spec:
  scaleTargetRef:
    kind: "Deployment"
    name: "nginx-1"
    apiVersion: "apps/v1"
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: "Resource"
    resource:
      name: "cpu"
      targetAverageUtilization: 80
```

```
kubectl apply -f ./nginx-deployment.yaml
```

## Task4. 워크로드 상세 정보 확인

```bash
kubectl get deployments
```

내용을 확인하고 scale 수를 조정
3 --> 1 --> 3

```
kubectl scale --replicas=3 deployment nginx-deployment
```

---

Docker 파일 구조

```
FROM
WORKDIR
RUN
COPY
CMD
```

