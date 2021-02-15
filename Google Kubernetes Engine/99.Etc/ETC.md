# Labs

### Deploying GKE Cluster

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

gcloud container clusters create $my_cluster --num-nodes 3 --zone $my_zone --enable-ip-alias

# modify GKE clusters
gcloud container clusters resize $my_cluster --zone $my_zone --num-nodes=4

# connect to GKE
gcloud container clusters get-credentials $my_cluster --zone $my_zone
nano ~/.kube/config

# inspect GKE cluster
kubectl config view
kubectl cluster-info

# change the active context
kubectl config use-context gke_${GOOGLE_CLOUD_PROJECT}_us-central1-a_standard-cluster-1

kubectl top nodes

# Deploy Pods to GKE
kubectl create deployment --image nginx nginx-1
kubectl get pods
export my_nginx_pod=[your_pod_name]
kubectl describe pod $my_nginx_pod

# Expose the Pod
kubectl expose pod $my_nginx_pod --port 80 --type LoadBalancer
kubectl get services
curl http://[EXTERNAL_IP]/test.html
kubectl top pods
```

### Creating GKE Deployments

```bash
kubectl apply -f ./nginx-deployment.yaml
kubectl get deployments

#  update the version of nginx
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl get deployments

kubectl rollout history deployment nginx-deployment

# Trigger a deployment rollback
kubectl rollout undo deployments nginx-deployment
kubectl rollout history deployment nginx-deployment
kubectl rollout history deployment/nginx-deployment --revision=3

# LoadBalancer creation
kubectl apply -f ./service-nginx.yaml
kubectl get service nginx

# Perform a canary deployment
kubectl apply -f nginx-canary.yaml
kubectl get deployments
kubectl scale --replicas=0 deployment nginx-deployment
kubectl get deployments
```

