# Deploying Google Kubernetes Engine Clusters from Cloud Shell
---

# 1.Deploy GKE Cluster

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1
gcloud container clusters create $my_cluster --num-nodes 3 --zone $my_zone --enable-ip-alias
```

# 2.GKE 클러스터 수정

```bash
gcloud container clusters resize $my_cluster --zone $my_zone --num-nodes=4
```

# 3.kubeconfig 파일 생성

```bash
gcloud container clusters get-credentials $my_cluster --zone $my_zone
nano ~/.kube/config
```

# 4.kubectl을 사용하여 GKE 클러스터 검사

```bash
kubectl config view
```
```apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED  #민감한 정보는 DATA+OMIITED로 대체
    server: https://34.72.222.228
  name: gke_qwiklabs-gcp-01-c09304efee98_us-central1-a_standard-cluster-1
  
  ...
```

Cloud Shell에서 클러스터 정보 출력

```bash
kubectl cluster-info
```

```bash
kubectl top nodes
```

# 5.GKE에 파드 배포

kubectl을 사용하여 GKE에 파드 배포

```bash
kubectl create deployment --image nginx nginx-1
kubectl get pods
kubectl describe pod $my_nginx_pod
```

컨테이너에 파일 푸시

```bash
nano ~/test.html
```
```html
<html> <header><title>This is title</title></header>
<body> Hello world </body>
</html>
```

```
kubectl cp ~/test.html $my_nginx_pod:/usr/share/nginx/html/test.html
```

테스트를 위한 파드 노출

```bash
kubectl expose pod $my_nginx_pod --port 80 --type LoadBalancer
```

```
kubectl get services
```
출력된 EXTERNAL-IP를 확인

```
curl http://[EXTERNAL_IP]/test.html
```


# 6.GKE 파드 검사

환경 준비

```
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/GKE_Shell/
```

샘플 파드 YAML 파일이 제공

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: new-nginx
  labels:
    name: new-nginx
spec:
  containers:
  - name: new-nginx
    image: nginx
    ports:
    - containerPort: 80
```

매니페스트를 배포

```
kubectl apply -f ./new-nginx-pod.yaml
kubectl get pods
```
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.

nano 편집기 설치
```
apt-get update
apt-get install nano
cd /usr/share/nginx/html
nano test.html
```

test.html
```html
<html> <header><title>This is title</title></header>
<body> Hello world </body>
</html>
```

Cloud Shell에서 nginx 파드로의 포트 포워드를 설정
```
kubectl port-forward new-nginx 10081:80
```

새로운 shell을 띄운 다음 다음의 명령어 실행

```
curl http://127.0.0.1:10081/test.html
```

새로운 shell을 또 띄운 다음 요청을 추가 발생


