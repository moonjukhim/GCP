/setup/training-data-analyst/courses/ahybrid/v1.0/

```bash
# env.sh
# general values
export HOME=~
export PATH=$PATH:$LAB_DIR/bin:
export PROJECT_ID=$(gcloud config get-value project)

# gke cluster values
export C1_NAME="gke-west"
export C1_ZONE="us-west2-a"
export C1_NODES=2
export C1_SCOPE="https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"

gcloud config set compute/zone $C1_ZONE
```

```bash
# install.sh
#!/usr/bin/env bash
source ./scripts/env.sh

apt-get install kubectl jq google-cloud-sdk-kpt -q -y

curl -sLO https://raw.githubusercontent.com/ahmetb/kubectx/v0.7.0/kubectx
chmod +x kubectx
mv kubectx $LAB_DIR/bin

curl -sLO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
mv kops-linux-amd64 $LAB_DIR/bin/kops

sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
```

```bash
# create_gke.sh
#!/usr/bin/env bash

echo "Creating the gke cluster..."
gcloud beta container clusters create ${C1_NAME} \
    --zone ${C1_ZONE} \
    --no-enable-basic-auth \
    --enable-autoupgrade \
    --max-surge-upgrade 1 \
    --max-unavailable-upgrade 0 \
    --enable-autorepair \
    --image-type "COS_CONTAINERD" \
    --release-channel "regular" \
    --machine-type=e2-standard-4 \
    --num-nodes=${C1_NODES} \
    --workload-pool=${WORKLOAD_POOL} \
    --logging=SYSTEM,WORKLOAD \
    --monitoring=SYSTEM \
    --metadata disable-legacy-endpoints=true \
    --labels mesh_id=${MESH_ID} \
    --addons HorizontalPodAutoscaling,HttpLoadBalancing \
    --default-max-pods-per-node "110" \
    --enable-ip-alias \
    --no-enable-master-authorized-networks \
    --subnetwork=default \
    --scopes ${C1_SCOPE}


echo "Registering the gke cluster..."
for (( i=1; i<=4; i++))
do
  res=$(gcloud container fleet memberships register ${C1_NAME}-connect --gke-cluster=${C1_ZONE}/${C1_NAME} --enable-workload-identity 2>&1)
  g1=$(echo $res | grep "PERMISSION_DENIED: hub default service account does not have access to the GKE cluster project for")
  g2=$(echo $res | grep -c "PERMISSION_DENIED: hub default service account does not have access to the GKE cluster project for")
  if [[ "$g2" == "0" ]]; then
    echo "Cluster registered!"
    break;
  fi
    echo "Permissions problem, waiting and retrying"
    sleep 60
done

# should add error checking
```

```bash
# create_remote.sh
#!/usr/bin/env bash

gsutil mb $KOPS_STORE

n=0
until [ $n -ge 5 ]
do
    gsutil ls | grep $KOPS_STORE && break
    n=$[$n+1]
    sleep 3
done

export K8S_VERSION="1.25.4"

echo "Creating the remote cluster..."
kops create cluster \
--name=$C2_FULLNAME \
--zones=$KOPS_ZONES \
--state=$KOPS_STORE \
--project=${PROJECT_ID} \
--node-count=$NODE_COUNT \
--node-size=$NODE_SIZE \
--admin-access=$INSTANCE_CIDR \
--kubernetes-version=$K8S_VERSION \
--yes

for (( c=1; c<=40; c++))
do
        echo "Check if cluster is ready - Attempt $c"
  CHECK=`kops validate cluster --name $C2_FULLNAME --state $KOPS_STORE | grep ready | wc -l`
  if [[ "$CHECK" == "1" ]]; then
    echo "Cluster is ready!"
    break;
  fi
  sleep 10
done

sleep 20

# SEE WHERE WE ARE HERE...
if [[ -f ".kube/config" ]]
then
  export KF=".kube/config"
else
  export KF="/root/.kube/config"
fi

echo "copying the kubeconfig file for later use..."
kops export kubecfg --name $C2_FULLNAME --state=$KOPS_STORE
gsutil cp $KF $KOPS_STORE

echo "creating service account and granting role..."
gcloud iam service-accounts create connect-sa-op

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member="serviceAccount:connect-sa-op@${PROJECT_ID}.iam.gserviceaccount.com" \
 --role="roles/gkehub.connect"

gcloud iam service-accounts keys create connect-sa-op-key.json \
  --iam-account=connect-sa-op@${PROJECT_ID}.iam.gserviceaccount.com

kubectl config view

echo "registering the remote cluster"
gcloud container fleet memberships register ${C2_NAME}-connect \
   --context=$C2_FULLNAME \
   --service-account-key-file=./connect-sa-op-key.json \
   --project=$PROJECT_ID \
   --kubeconfig $KF

echo "creating a clusterrolebinding"
export KSA=remote-admin-sa
kubectl create serviceaccount $KSA
kubectl create clusterrolebinding ksa-admin-binding \
    --clusterrole cluster-admin \
    --serviceaccount default:$KSA
```
