/setup/training-data-analyst/courses/ahybrid/v1.0/
/setup/training-data-analyst/courses/ahybrid/v1.0/common/script/
-rw-r--r-- 1 root root 2188 Apr 18 21:56 acm.sh
-rw-r--r-- 1 root root 887 Apr 18 21:56 asmcli.sh
-rw-r--r-- 1 root root 353 Apr 18 21:56 bookinfo.sh
-rwxr-xr-x 1 root root 1563 Apr 18 21:56 c2.sh
-rw-r--r-- 1 root root 2021 Apr 18 21:56 create_gke.sh
-rw-r--r-- 1 root root 2659 Apr 18 21:56 create_remote.sh
-rwxr-xr-x 1 root root 1146 Apr 18 21:56 install.sh
-rw-r--r-- 1 root root 206 Apr 18 21:56 istio.sh
-rw-r--r-- 1 root root 708 Apr 18 21:56 microservices-demo.sh
-rwxr-xr-x 1 root root 1066 Apr 18 21:56 services.sh
-rw-r--r-- 1 root root 166 Apr 18 21:56 tracing.yaml

```bash
# load.sh
chmod +x ../common/scripts/services.sh # enable google cloud service(continer, compute, ...)
../common/scripts/services.sh

source ./scripts/env.sh # setting environment variables

chmod +x ../common/scripts/install.sh # install apt-get, kubectx, kops
../common/scripts/install.sh

chmod +x ../common/scripts/create_gke.sh
../common/scripts/create_gke.sh

gcloud beta runtime-config configs variables set success/${HOSTNAME} success \
  --config-name ${HOSTNAME}-config >>${PROJECT_ID}.txt
```

```bash
# scripts/env.sh
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
