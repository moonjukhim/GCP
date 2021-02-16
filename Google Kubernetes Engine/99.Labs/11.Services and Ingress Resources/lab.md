# Creating Services and Ingress Resources

### 작업1. GKE 클러스터에 연결

### 작업2. Pod와 DNS 해석을 위한 서비스 생성

### 작업3. 샘플 워크로드와 ClusterIp 서비스 배포

### 작업4. NodePort 서비스 배포

### 작업5. Google Cloud Network를 사용한 정적 고정 IP 생성

### 작업6. 새 파드와 로드밸랜서 서비스 배포

### 작업7. 인그레스(Ingress) 배포

---

### Task1. Connect to the GKE cluster and test DNS

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone
```


### Task2. Create Pods and services to test DNS resolution

dns-demo.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: dns-demo
spec:
  selector:
    name: dns-demo
  clusterIP: None
  ports:
  - name: dns-demo
    port: 1234
    targetPort: 1234
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-demo-1
  labels:
    name: dns-demo
spec:
  hostname: dns-demo-1
  subdomain: dns-demo
  containers:
  - name: nginx
    image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-demo-2
  labels:
    name: dns-demo
spec:
  hostname: dns-demo-2
  subdomain: dns-demo
  containers:
  - name: nginx
    image: nginx
```

```bash
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/GKE_Services/
kubectl apply -f dns-demo.yaml
kubectl get pods
```

```
kubectl exec -it dns-demo-1 /bin/bash
```

ping from "dns-demo-1" to "dns-demo-2"

```bash
apt-get update
apt-get install -y iputils-ping
ping dns-demo-2.dns-demo.default.svc.cluster.local
```

## Task3. Deploy a sample workload and a ClusterIP service

Deploy a sample web application to your Kubernetes Engine cluster

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-v1
spec:
  replicas: 3
  selector:
    matchLabels:
      run: hello-v1
  template:
    metadata:
      labels:
        run: hello-v1
        name: hello-v1
    spec:
      containers:
      - image: gcr.io/google-samples/hello-app:1.0
        name: hello-v1
        ports:
        - containerPort: 8080
          protocol: TCP
```

새로운 터미널을 오픈

```bash
cd ~/ak8s/GKE_Services/
kubectl create -f hello-v1.yaml
kubectl get deployments
```

Define service types in the manifest

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
spec:
  type: ClusterIP
  selector:
    name: hello-v1
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

```bash
kubectl apply -f ./hello-svc.yaml
kubectl get service hello-svc
```

Test application

```bash
curl hello-svc.default.svc.cluster.local
# This should fail
```


## Task4. Convert the service to use NodePort

hello-nodeport-svc.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
spec:
  type: NodePort
  selector:
    name: hello-v1
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
    nodePort: 30100
```

```bash
kubectl apply -f ./hello-nodeport-svc.yaml
kubectl get service hello-svc
```

애플리케이션 테스트

```bash
curl hello-svc.default.svc.cluster.local
```

## Task5. Create static public IP addresses using Google Cloud Networking



## Task6. Deploy a new set of Pods and a LoadBalancer service

hello-v2.yaml

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-v2
spec:
  replicas: 3
  selector:
    matchLabels:
      run: hello-v2
  template:
    metadata:
      labels:
        run: hello-v2
        name: hello-v2
    spec:
      containers:
      - image: gcr.io/google-samples/hello-app:2.0
        name: hello-v2
        ports:
        - containerPort: 8080
          protocol: TCP
```

Define service types in the manifest

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-lb-svc
spec:
  type: LoadBalancer
  loadBalancerIP: 10.10.10.10
  selector:
    name: hello-v2
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

```bash
export STATIC_LB=$(gcloud compute addresses describe regional-loadbalancer --region us-central1 --format json | jq -r '.address')

sed -i "s/10\.10\.10\.10/$STATIC_LB/g" hello-lb-svc.yaml

cat hello-lb-svc.yaml

kubectl apply -f ./hello-lb-svc.yaml
kubectl get services
```

애플리케이션 테스트

```bash
curl hello-lb-svc.default.svc.cluster.local
# curl: (6) Could not resolve host: hello-lb-svc.default.svc.cluster.local

curl [external_IP]
curl hello-lb-svc.default.svc.cluster.local
```

## Task7. Deploy and Ingress resource

hello-ingress.yaml

```yaml
apiVersion: app/v1
kind: Ingress
metadata:
  name: hello-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    kubernetes.io/ingress.global-static-ip-name: "global-ingress"

spec:
  rules:
  - http:
      Paths:
     - path: /v1
        backend:
          serviceName: hello-svc
          servicePort: 80
      - path: /v2
        backend:
          serviceName: hello-lb-svc
          servicePort: 80
```

```bash
kubectl describe ingress hello-ingress
```

출력된 Message의 ip 주소로 확인

```
curl http://[external_IP]/v1
```


