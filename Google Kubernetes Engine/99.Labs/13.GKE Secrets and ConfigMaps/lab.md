# Working with Google Kubernetes Engine Secrets and ConfigMaps

### 작업1. Secret 사용

###

---

### Task1. Work with Secrets

이 작업에서는 GCP 서비스에 액세스하기 위해 GCP로 컨테이너를 인증합니다. Cloud Pub/Sub 주제 및 구독을 설정하고 GKE에서 실행중인 컨테이너에서 Cloud Pub/Sub 주제에 액세스를 시도한 후 액세스 요청이 실패하는지 확인합니다. 게시/구독 주제에 올바르게 액세스하려면 사용자 인증 정보로 서비스 계정을 만들고 Kubernetes Secrets을 통해 해당 사용자 인증 정보를 전달합니다.

Cloud Pub / Sub를 설정하고 주제에서 읽을 애플리케이션을 배포

```bash
export my_pubsub_topic=echo
export my_pubsub_subscription=echo-read

gcloud pubsub topics create $my_pubsub_topic
gcloud pubsub subscriptions create $my_pubsub_subscription \
 --topic=$my_pubsub_topic
```

pubsub.yaml 매니페스트 파일

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pubsub
spec:
  selector:
    matchLabels:
      app: pubsub
  template:
    metadata:
      labels:
        app: pubsub
    spec:
      containers:
      - name: subscriber
        image: gcr.io/google-samples/pubsub-sample:v1
```

```bash
kubectl apply -f pubsub.yaml
# 프로그램이 시작되지만 정상 동작하지 않음
kubectl get pods -l app=pubsub
```

자격 증명을 비밀로 가져오기

```bash
ls ~/
kubectl create secret generic pubsub-key \
 --from-file=key.json=$HOME/credentials.json

rm -rf ~/credentials.json
```

pubsub-secret.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pubsub
spec:
  selector:
    matchLabels:
      app: pubsub
  template:
    metadata:
      labels:
        app: pubsub
    spec:
      volumes:
      - name: google-cloud-key
        secret:
          secretName: pubsub-key
      containers:
      - name: subscriber
        image: gcr.io/google-samples/pubsub-sample:v1
        volumeMounts:
        - name: google-cloud-key
          mountPath: /var/secrets/google
        env:
        - name: GOOGLE_APPLICATION_CREDENTIALS
          value: /var/secrets/google/key.json  ##
```

Cloud Pub/Sub 메시지 수신 테스트

```bash
gcloud pubsub topics publish $my_pubsub_topic --message="Hello, world!"
# 배포된 파드의 로그를 검사
kubectl logs -l app=pubsub
```

### Task2. Work with ConfigMaps

ConfigMap은 구성 파일, 명령 줄 인수, 환경 변수, 포트 번호, 기타 구성 아티팩트를 런타임에 포드의 컨테이너 및 시스템 구성 요소에 바인딩합니다. ConfigMaps를 사용하면 포드 및 구성 요소에서 구성을 분리 할 수 ​​있습니다. 그러나 ConfigMap은 암호화되지 않으므로 자격 증명에 적합하지 않습니다. 이것이 비밀과 ConfigMap의 차이점입니다. 

```bash
kubectl create configmap sample --from-literal=message=hello

kubectl describe configmaps sample

kubectl create configmap sample2 --from-file=sample2.properties
kubectl describe configmaps sample2
```

매니페스트 파일을 사용하여 ConfigMap 생성

```yaml
apiVersion: v1
data:
  airspeed: africanOrEuropean
  meme: testAllTheThings
kind: ConfigMap
metadata:
  name: sample3
  namespace: default
  selfLink: /api/v1/namespaces/default/configmaps/sample3
```

YAML파일에서 ConfigMap을 생성

```bash
kubectl apply -f config-map-3.yaml
kubectl describe configmaps sample3
```

```bash
kubectl get pods
# 셸 세션을 시작
kubectl exec -it [MY-POD-NAME] -- sh
```

파드의 셸 세션에서

```bash
printenv
exit
```

