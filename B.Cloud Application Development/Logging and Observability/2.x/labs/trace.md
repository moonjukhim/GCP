```bash
git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git
gcloud services enable container.googleapis.com
ZONE=us-central1-b
gcloud container clusters create cloud-trace-demo  --zone $ZONE
gcloud container clusters get-credentials cloud-trace-demo --zone $ZONE
cd python-docs-samples/trace/cloud-trace-demo-app-opentelemetry && ./setup.sh

###
curl $(kubectl get svc -o=jsonpath='{.items[?(@.metadata.name=="cloud-trace-demo-a")].status.loadBalancer.ingress[0].ip}')
```
