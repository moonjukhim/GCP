1. 서비스 계정 생성

```bash
# gcloud container clusters get-credentials NAME [--internal-ip] [--region=REGION     | --zone=ZONE, -z ZONE] [GCLOUD_WIDE_FLAG …]
export PROJECT_ID=$(gcloud config get-value core/project) 
export SERVICE_ACCOUNT_NAME="my-app-gcs-service-account" 
export GCS_BUCKET_NAME="my-app-[UNIQUE VALUE]" # 이름이 중복되지 않도록 고유한 이름
```

2. 버킷 생성
```bash
gsutil mb gs://${GCS_BUCKET_NAME}/
```

3. 서비스 계정 생성

```bash
gcloud iam service-accounts create ${SERVICE_ACCOUNT_NAME}  --display-name="my-app-gcs-service-account"
gcloud iam service-accounts list
gsutil iam ch serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com:objectAdmin gs://${GCS_BUCKET_NAME}/
gcloud iam service-accounts keys create --iam-account "${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" service-account.json
```

4. 쿠버네티스 시크릿 생성

```bash
kubectl create secret generic my-app-sa-key --from-file service-account.json
kubectl get secret
```

5. 애플리케이션 배포

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      name: my-app
      labels:
        app: my-app
    spec:
      containers:
        - name: my-app
          image: nginx:1.7.9
          env:
            - name: "BUCKET_NAME"
              value: "my-data-disk"
            - name: "GOOGLE_APPLICATION_CREDENTIALS"
              value: "/var/run/secret/cloud.google.com/service-account.json"
          volumeMounts:
            - name: "service-account"
              mountPath: "/var/run/secret/cloud.google.com"
            - name: "certs"
              mountPath: "/etc/ssl/certs"
      volumes:
        - name: "service-account"
          secret:
            secretName: "my-app-sa-key"
        - name: "certs"
          hostPath:
            path: "/etc/ssl/certs"
```

```bash
kubectl apply -f my-app.yaml
```
