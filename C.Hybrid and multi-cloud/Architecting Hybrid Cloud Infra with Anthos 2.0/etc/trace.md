
1. Install ASM with tracing enabled

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
```


2. 

```bash
kubectl label namespace default istio.io/rev=asm-managed --overwrite
kubectl annotate --overwrite namespace default \
  mesh.cloud.google.com/proxy='{"managed":"true"}'
  kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/master/release/kubernetes-manifests.yaml
kubectl patch deployments/productcatalogservice -p '{"spec":{"template":{"metadata":{"labels":{"version":"v1"}}}}}'
```


3. 

