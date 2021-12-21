### Architecting Hybrid Cloud Infrastructure with Anthos
---
1. Introducing Anthos
2. Building Multi/Hybrid-cloud solutions with Anthos Clusters
3. Introducing Service Mesh (Installing Anthos Service Mesh)
4. Observing Anthos Services (Service Observability in Anthos)
5. Managing Traffic Flow with Anthos Service Mesh (Lab)
6. Securing Network Traffic with Anthos Service Mesh (Lab)
7. Managing Multiple Clusters with Anthos Config Managment (Lab)
8. Networking Multiple Clusters (Lab: Configuring a Multi-cluster Mesh)

---

```bash
gcloud services enable \
    cloudresourcemanager.googleapis.com \
    container.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    serviceusage.googleapis.com \
    anthos.googleapis.com

git clone -b workshop-v1 https://github.com/GoogleCloudPlatform/anthos-workshop.git anthos-workshop

cd anthos-workshop
sed -i '/kops export/s/$/ --admin/' common/connect-kops-remote.sh

source ./common/connect-kops-remote.sh
```

```
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-central1-b
export CLUSTER_VERSION=latest

gcloud beta container clusters create $CLUSTER_NAME \
    --zone $CLUSTER_ZONE --num-nodes 4 \
    --machine-type "n1-standard-2" --image-type "COS" \
    --cluster-version=$CLUSTER_VERSION --enable-ip-alias \
    --addons=Istio --istio-config=auth=MTLS_STRICT

export GCLOUD_PROJECT=$(gcloud config get-value project)
gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $CLUSTER_ZONE --project $GCLOUD_PROJECT

kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)

gcloud container clusters list
kubectl get service -n istio-system

export LAB_DIR=$HOME/bookinfo-lab
export ISTIO_VERSION=1.4.6
mkdir $LAB_DIR
cd $LAB_DIR
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=$ISTIO_VERSION sh -

cd ./istio-*
export PATH=$PWD/bin:$PATH
istioctl version

```

