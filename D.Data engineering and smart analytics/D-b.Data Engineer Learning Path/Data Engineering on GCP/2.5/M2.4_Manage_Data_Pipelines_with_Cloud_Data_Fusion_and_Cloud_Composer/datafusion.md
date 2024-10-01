##### Task1. Data Fusion 인스턴스 생성

```bash
gcloud services disable datafusion.googleapis.com
gcloud services enable datafusion.googleapis.com
```

```bash
gcloud beta data-fusion instances create my-instance --project=my-project --location=my-location --zone=my-zone
```
