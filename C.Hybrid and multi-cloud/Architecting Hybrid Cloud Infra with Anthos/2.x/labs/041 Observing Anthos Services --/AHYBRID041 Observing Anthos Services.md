# Task1. Install Anthos Service Mesh

```bash
CLUSTER_NAME=gke
CLUSTER_ZONE=us-west1-b
PROJECT_ID=[PROJECT_ID]
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
  --format="value(projectNumber)")
FLEET_PROJECT_ID="${PROJECT_ID}"
IDNS="${PROJECT_ID}.svc.id.goog"
DIR_PATH=.
printf '\nCLUSTER_NAME:'$CLUSTER_NAME'\nCLUSTER_ZONE:'$CLUSTER_ZONE'\nPROJECT_ID:'$PROJECT_ID'\nPROJECT_NUMBER:'$PROJECT_NUMBER'\nFLEET PROJECT_ID:'$FLEET_PROJECT_ID'\nIDNS:'$IDNS'\nDIR_PATH:'$DIR_PATH'\n'
gcloud container clusters get-credentials $CLUSTER_NAME \
     --zone $CLUSTER_ZONE --project $PROJECT_ID
kubectl config view
gcloud container clusters list
```

```bash
sudo curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 -o /usr/bin/asmcli && sudo chmod +x /usr/bin/asmcli
asmcli --version
 asmcli install \
 --project_id $PROJECT_ID \
 --cluster_name $CLUSTER_NAME \
 --cluster_location $CLUSTER_ZONE \
 --fleet_id $FLEET_PROJECT_ID \
 --output_dir $DIR_PATH \
 --managed \
 --enable_all \
 --ca mesh_ca

cat <<EOF | kubectl apply -f -
apiVersion: v1
data:
  mesh: |-
    defaultConfig:
      tracing:
        stackdriver: {}
kind: ConfigMap
metadata:
  name: istio-asm-managed
  namespace: istio-system
EOF

kubectl get configmap
```

# Task2. Install app on the cluster

```bash
kubectl label namespace default istio.io/rev=asm-managed --overwrite
kubectl annotate --overwrite namespace default \
  mesh.cloud.google.com/proxy='{"managed":"true"}'
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
kubectl patch deployments/productcatalogservice -p '{"spec":{"template":{"metadata":{"labels":{"version":"v1"}}}}}'
git clone https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages
kubectl apply -f anthos-service-mesh-packages/samples/gateways/istio-ingressgateway
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/istio-manifests.yaml

# https://github.com/GoogleCloudPlatform/microservices-demo
```
