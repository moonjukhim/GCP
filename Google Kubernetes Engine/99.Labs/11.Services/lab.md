# Creating Services and Ingress Resources

## Task1. Connect to the GKE cluster and test DNS

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone
```


## Task2. Create Pods and services to test DNS resolution

```yaml
apiVersion: v1
kind: Service
metadata:
  name: dns-demo
spec:
  selector:
    name: dns-demo
  clusterIP: None
  ports:
  - name: dns-demo
    port: 1234
    targetPort: 1234
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-demo-1
  labels:
    name: dns-demo
spec:
  hostname: dns-demo-1
  subdomain: dns-demo
  containers:
  - name: nginx
    image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: dns-demo-2
  labels:
    name: dns-demo
spec:
  hostname: dns-demo-2
  subdomain: dns-demo
  containers:
  - name: nginx
    image: nginx
```

```bash
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/GKE_Services/
kubectl apply -f dns-demo.yaml
kubectl get pods
```

```
kubectl exec -it dns-demo-1 /bin/bash
```

```
apt-get update
apt-get install -y iputils-ping
ping dns-demo-2.dns-demo.default.svc.cluster.local
```

## Task3. Deploy a sample workload and a ClusterIP service

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-v1
spec:
  replicas: 3
  selector:
    matchLabels:
      run: hello-v1
  template:
    metadata:
      labels:
        run: hello-v1
        name: hello-v1
    spec:
      containers:
      - image: gcr.io/google-samples/hello-app:1.0
        name: hello-v1
        ports:
        - containerPort: 8080
          protocol: TCP
```

새로운 터미널을 오픈

```
cd ~/ak8s/GKE_Services/
kubectl create -f hello-v1.yaml
kubectl get deployments
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-svc
spec:
  type: ClusterIP
  selector:
    name: hello-v1
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
```

```bash
kubectl apply -f ./hello-svc.yaml
kubectl get service hello-svc
```

Test application

```bash
curl hello-svc.default.svc.cluster.local
# This should fail
```


## Task4. Convert the service to use NodePort


## Task5. Create static public IP addresses using Google Cloud Networking

## Task6. Deploy a new set of Pods and a LoadBalancer service

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-v2
spec:
  replicas: 3
  selector:
    matchLabels:
      run: hello-v2
  template:
    metadata:
      labels:
        run: hello-v2
        name: hello-v2
    spec:
      containers:
      - image: gcr.io/google-samples/hello-app:2.0
        name: hello-v2
        ports:
        - containerPort: 8080
          protocol: TCP
```


## Task7. Deploy and Ingress resource



