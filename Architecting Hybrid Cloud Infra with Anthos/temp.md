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



---

```bash
export PROJECT_ID=$(gcloud config get-value project)
export CLUSTER_NAME=central
export CLUSTER_ZONE=us-central1-b

gcloud container clusters get-credentials $CLUSTER_NAME \
    --zone $CLUSTER_ZONE --project $PROJECT_ID

gcloud container clusters list

```

```bash
curl https://storage.googleapis.com/csm-artifacts/asm/install_asm_1.9 > install_asm
chmod +x install_asm
./install_asm \
--project_id $PROJECT_ID \
--cluster_name $CLUSTER_NAME \
--cluster_location $CLUSTER_ZONE \
--mode install \
--enable_gcp_apis \
--enable_all
kubectl get pod -n istio-system

kubectl -n istio-system get pods -l app=istiod --show-labels
```

git clone -b workshop-v1 https://github.com/GoogleCloudPlatform/anthos-workshop.git anthos-workshop