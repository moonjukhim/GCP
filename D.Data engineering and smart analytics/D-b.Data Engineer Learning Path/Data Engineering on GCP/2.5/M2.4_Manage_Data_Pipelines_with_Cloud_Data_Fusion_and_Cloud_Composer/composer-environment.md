### Cloud Composer Creation

1. Environment 생성

```bash
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")

gcloud projects add-iam-policy-binding qwiklabs-gcp-04-6569d6aec531 \
--member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
--role=roles/composer.worker

gcloud services disable composer.googleapis.com
gcloud services disable artifactregistry.googleapis.com
gcloud services disable container.googleapis.com

gcloud services enable artifactregistry.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable composer.googleapis.com
```

2. Cloud Composer environment 생성
