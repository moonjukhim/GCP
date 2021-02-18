# Configuring Persistent Storage for Google Kubernetes Engine

### 작업1 : PV 및 PVC 생성


---

### Task1 : PV 및 PVC 생성

- Google Cloud 영구 디스크 (동적으로 생성되거나 기존) 용 PersistentVolume (PV) 및 PersistentVolumeClaims (PVC)에 대한 매니페스트를 만듭니다.
- Google Cloud 영구 디스크 PVC를 포드의 볼륨으로 마운트
- 매니페스트를 사용하여 StatefulSet 만들기
- Google Cloud 영구 디스크 PVC를 StatefulSet의 볼륨으로 마운트
- Pod가 중지되고 다시 시작될 때 StatefulSet의 Pod와 특정 PV의 연결을 확인합니다.

PVC를 사용하여 매니페스트 생성 및 적용

pvc-demo.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: hello-web-disk
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 30Gi
```

```bash
kubectl apply -f pvc-demo.yaml
kubectl get persistentvolumeclaim
```
### Task2: 파드에 Google Cloud 영구 디스크 PVC 마운트 및 확인

매니페스트 파일 pod-volume-demo.yaml은 nginx 컨테이너를 배포하고 pvc-demo-volumePod에 연결하고 해당 볼륨을 /var/www/htmlnginx 컨테이너 내부의 경로에 마운트합니다 .

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: pvc-demo-pod
spec:
  containers:
    - name: frontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: pvc-demo-volume
  volumes:
    - name: pvc-demo-volume
      persistentVolumeClaim:
        claimName: hello-web-disk
```

```bash
kubectl apply -f pod-volume-demo.yaml
kubectl get pods
```

파드 내에서 PVC에 액세스 할 수 있는지 확인

```bash
kubectl exec -it pvc-demo-pod -- sh
```

파드에서 다음의 작업을 수행

```
echo Test webpage in a persistent volume!>/var/www/html/index.html
chmod +x /var/www/html/index.html

cat /var/www/html/index.html

exit
```

PV의 지속성 테스트

```bash
kubectl delete pod pvc-demo-pod
kubectl get pods

kubectl get persistentvolumeclaim
```

pvc-demo-pod를 다시 배포

```bash
kubectl apply -f pod-volume-demo.yaml
kubectl get pods
```

PVC가 파드 내에서 계속 액세스 가능한지 확인

```bash
kubectl exec -it pvc-demo-pod -- sh
```

파드 내에서 실행
```
cat /var/www/html/index.html
exit
```

### Task3 : PVC를 사용하여 StatefulSet 만들기

StatefulSet은 Pod에 고유 한 식별자가 부여된다는 점을 제외하면 Deployment와 유사합니다.

Release the PVC

```bash
kubectl delete pod pvc-demo-pod
kubectl get pods
```

Create a StatefulSet, statefulset-demo.yaml

```yaml
kind: Service
apiVersion: v1
metadata:
  name: statefulset-demo-service
spec:
  ports:
  - protocol: TCP
    port: 80
    targetPort: 9376
  type: LoadBalancer
---

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: statefulset-demo
spec:
  selector:
    matchLabels:
      app: MyApp
  serviceName: statefulset-demo-service
  replicas: 3
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: MyApp
    spec:
      containers:
      - name: stateful-set-container
        image: nginx
        ports:
        - containerPort: 80
          name: http
        volumeMounts:
        - name: hello-web-disk
          mountPath: "/var/www/html"
  volumeClaimTemplates:
  - metadata:
      name: hello-web-disk
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 30Gi
```

```bash
kubectl apply -f statefulset-demo.yaml

kubectl describe statefulset statefulset-demo

kubectl get pods

kubectl get pvc

kubectl describe pvc hello-web-disk-statefulset-demo-0
```


### Task4 : Verify the persistence of Persistent Volume connections to Pods managed by StatefulSets

```bash
kubectl exec -it statefulset-demo-0 -- sh
```