# Labs

### Deploying GKE Cluster

```
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



