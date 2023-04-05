1. gke 클러스터

   - ASM을 사용하기 위한 최소 노드 사양 : e2-standard-4
   - mesh_id : proj-768458176611
   - workload identity 설정
   - /setup/training-data-analyst/courses/ahybrid/v1.0/AHYBRID031
   - export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
   - export MESH_ID="proj-${PROJECT_NUMBER}"

```bash
export PROJECT_ID=$(gcloud config get-value project)
export C1_NAME="gke"
export C1_ZONE="us-central1-b"
export C1_NODES=2
export C1_SCOPE="https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append"
export PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} \
    --format="value(projectNumber)")
export WORKLOAD_POOL=${PROJECT_ID}.svc.id.goog
export MESH_ID="proj-${PROJECT_NUMBER}"

export CLUSTER_NAME="gke"
export CLUSTER_ZONE="us-central1-b"

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
```

2.
