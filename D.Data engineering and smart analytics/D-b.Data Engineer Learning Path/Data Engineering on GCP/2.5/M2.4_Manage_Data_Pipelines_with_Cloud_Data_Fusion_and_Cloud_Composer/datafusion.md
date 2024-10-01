##### Task1. Data Fusion 인스턴스 생성

```bash
gcloud services disable datafusion.googleapis.com
gcloud services enable datafusion.googleapis.com
```

```bash
gcloud beta data-fusion instances create cloudfusion --project=qwiklabs-gcp-04-3ee183e77a2c --location=my-location --zone=my-zone
```

```bash
export BUCKET=$GOOGLE_CLOUD_PROJECT
gcloud storage buckets create gs://$BUCKET
gcloud storage cp gs://cloud-training/OCBL017/ny-taxi-2018-sample.csv gs://$BUCKET
```
