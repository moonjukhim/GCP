### 081 Configuring a multi-cluster mesh with Anthos Service Mesh

1. Prepare to install Anthos Service Mesh
2. Install Anthos Service Mesh on both clusters
3. Configure the mesh to span both clusters
4. Review Service Mesh control planes
5. Deploy the Online application across multiple clusters
6. Evaluate your multi-cluster application
7. Distribute one service across both clusters

---

1. Prepare to install Anthos Service Mesh

```bash
C1_LOCATION=us-west1-c
C2_LOCATION=europe-west1-b
export PROJECT_ID=${PROJECT_ID:-$(gcloud config get-value project)}
export C1_NAME=west
export C2_NAME=east
export FLEET_PROJECT_ID=${FLEET_PROJECT_ID:-$PROJECT_ID}
export DIR_PATH=${DIR_PATH:-$(pwd)}
export GATEWAY_NAMESPACE=asm-gateways

curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.17 > asmcli
chmod +x asmcli

# configure the west cluster context
gcloud container clusters get-credentials $C1_NAME --zone $C1_LOCATION --project $PROJECT_ID
kubectx $C1_NAME=.

# configure the east cluster context
gcloud container clusters get-credentials $C2_NAME --zone $C2_LOCATION --project $PROJECT_ID
kubectx $C2_NAME=.

kubectx
```


2. Install Anthos Service Mesh on both clusters

```bash
# switch to west context
kubectx west

# install Anthos Service Mesh
./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $C1_NAME \
  --cluster_location $C1_LOCATION \
  --fleet_id $FLEET_PROJECT_ID \
  --output_dir $DIR_PATH \
  --enable_all \
  --ca mesh_ca

# create the gateway namespace
kubectl create namespace $GATEWAY_NAMESPACE

# enable sidecar injection on the gateway namespace
kubectl label ns $GATEWAY_NAMESPACE \
  istio.io/rev=$(kubectl -n istio-system get pods -l app=istiod -o json | jq -r '.items[0].metadata.labels["istio.io/rev"]') \
  --overwrite

# Apply the configurations
kubectl apply -n $GATEWAY_NAMESPACE \
  -f $DIR_PATH/samples/gateways/istio-ingressgateway
```
```bash
# switch to the east context
kubectx east

# install Anthos Service Mesh
./asmcli install \
  --project_id $PROJECT_ID \
  --cluster_name $C2_NAME \
  --cluster_location $C2_LOCATION \
  --fleet_id $FLEET_PROJECT_ID \
  --output_dir $DIR_PATH \
  --enable_all \
  --ca mesh_ca

# create the gateway namespace
kubectl create namespace $GATEWAY_NAMESPACE

# enable sidecar injection on the gateway namespace
kubectl label ns $GATEWAY_NAMESPACE \
  istio.io/rev=$(kubectl -n istio-system get pods -l app=istiod -o json | jq -r '.items[0].metadata.labels["istio.io/rev"]') \
  --overwrite

# Apply the configurations
kubectl apply -n $GATEWAY_NAMESPACE \
  -f $DIR_PATH/samples/gateways/istio-ingressgateway
```

3. Configure the mesh to span both clusters

```bash
 function join_by { local IFS="$1"; shift; echo "$*"; }

 # get the service IP CIDRs for each cluster
 ALL_CLUSTER_CIDRS=$(gcloud container clusters list \
   --filter="name:($C1_NAME,$C2_NAME)" \
   --format='value(clusterIpv4Cidr)' | sort | uniq)
 ALL_CLUSTER_CIDRS=$(join_by , $(echo "${ALL_CLUSTER_CIDRS}"))

 # get the network tags for each cluster
 ALL_CLUSTER_NETTAGS=$(gcloud compute instances list  \
   --filter="name:($C1_NAME,$C2_NAME)" \
   --format='value(tags.items.[0])' | sort | uniq)
 ALL_CLUSTER_NETTAGS=$(join_by , $(echo "${ALL_CLUSTER_NETTAGS}"))

 # create the firewall rule allowing traffic between the clusters
 gcloud compute firewall-rules create istio-multi-cluster-pods \
     --allow=tcp,udp,icmp,esp,ah,sctp \
     --direction=INGRESS \
     --priority=900 \
     --source-ranges="${ALL_CLUSTER_CIDRS}" \
     --target-tags="${ALL_CLUSTER_NETTAGS}" --quiet

./asmcli create-mesh \
    $FLEET_PROJECT_ID \
    ${PROJECT_ID}/${C1_LOCATION}/${C1_NAME} \
    ${PROJECT_ID}/${C2_LOCATION}/${C2_NAME}
```

4. Review Service Mesh control planes

```bash
kubectx west
kubectl get namespaces
```

5. Deploy the Online application across multiple clusters

```bash
# switch to the west context
kubectx west

# create the namespace
kubectl create ns boutique

# enable sidecar injection
kubectl label ns boutique \
  istio.io/rev=$(kubectl -n istio-system get pods -l app=istiod -o json | jq -r '.items[0].metadata.labels["istio.io/rev"]') \
  --overwrite

git clone https://github.com/GoogleCloudPlatform/training-data-analyst
cd training-data-analyst/courses/ahybrid/v1.0/AHYBRID081/boutique/

kubectl apply -n boutique -f west

# switch to the east context
kubectx east

# create the namespace
kubectl create ns boutique

# enable sidecar injection
kubectl label ns boutique \
  istio.io/rev=$(kubectl -n istio-system get pods -l app=istiod -o json | jq -r '.items[0].metadata.labels["istio.io/rev"]') \
  --overwrite

kubectl apply -n boutique -f east/deployments.yaml
kubectl apply -n boutique -f east/services.yaml
kubectl apply -n boutique -f east/istio-defaults.yaml
```

6. Evaluate your multi-cluster application

```bash
# get the IP address for the west cluster service
kubectx west
export WEST_GATEWAY_URL=http://$(kubectl get svc istio-ingressgateway \
-o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n asm-gateways)

# get the IP address for the east cluster service
kubectx east
export EAST_GATEWAY_URL=http://$(kubectl get svc istio-ingressgateway \
-o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n asm-gateways)

# compose and output the URLs for each service
echo "The gateway address for west is $WEST_GATEWAY_URL
The gateway address for east is $EAST_GATEWAY_URL
"
```

7. Distribute one service across both clusters


---

https://overcast.blog/building-and-managing-multi-cloud-kubernetes-clusters-in-2024-25f1febe6ef3
