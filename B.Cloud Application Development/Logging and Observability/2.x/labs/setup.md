setup.sh

```bash
set -o errexit  # exit on error
SCRIPT_DIR=$(realpath $(dirname "$0"))
pushd $SCRIPT_DIR > /dev/null

echo ################## Set up cloud trace demo application ###########################
kubectl apply -f app/cloud-trace-demo.yaml

echo ""
echo -n "Wait for load balancer initialization complete."
for run in {1..20}
do
  sleep 5
  endpoint=`kubectl get svc cloud-trace-demo-a -ojsonpath='{.status.loadBalancer.ingress[0].ip}'`
  if [[ "$endpoint" != "" ]]; then
    break
  fi
  echo -n "."
done

echo ""
if [ -n "$endpoint" ]; then
  echo "Completed. You can access the demo at http://${endpoint}/"
else
  echo "There is a problem with the setup. Cannot determine the endpoint."
fi
popd
```

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloud-trace-demo-a
  labels:
    app: cloud-trace-demo-app-a
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cloud-trace-demo-app-a
  template:
    metadata:
      name: cloud-trace-demo-a
      labels:
        app: cloud-trace-demo-app-a
    spec:
      containers:
        - name: cloud-trace-demo-container
          image: gcr.io/google_samples/cloud-trace-demo-opentelemetry:latest
          imagePullPolicy: "Always"
          command:
            - python
          args:
            - app.py
          ports:
            - containerPort: 8080
          env:
            - name: PORT
              value: "8080"
            - name: KEYWORD
              value: "Hello, I am service A"
            - name: ENDPOINT
              value: "http://cloud-trace-demo-b:8090"
---
apiVersion: v1
kind: Service
metadata:
  name: cloud-trace-demo-a
spec:
  selector:
    app: cloud-trace-demo-app-a
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloud-trace-demo-b
  labels:
    app: cloud-trace-demo-app-b
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cloud-trace-demo-app-b
  template:
    metadata:
      name: cloud-trace-demo-b
      labels:
        app: cloud-trace-demo-app-b
    spec:
      containers:
        - name: cloud-trace-demo-container
          image: gcr.io/google_samples/cloud-trace-demo-opentelemetry:latest
          imagePullPolicy: "Always"
          command:
            - python
          args:
            - app.py
          ports:
            - containerPort: 8090
          env:
            - name: PORT
              value: "8090"
            - name: KEYWORD
              value: "And I am service B"
            - name: ENDPOINT
              value: "http://cloud-trace-demo-c:8090"

---
apiVersion: v1
kind: Service
metadata:
  name: cloud-trace-demo-b
spec:
  selector:
    app: cloud-trace-demo-app-b
  ports:
    - protocol: TCP
      port: 8090
      targetPort: 8090
  type: ClusterIP

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloud-trace-demo-c
  labels:
    app: cloud-trace-demo-app-c
spec:
  replicas: 1
  selector:
    matchLabels:
      app: cloud-trace-demo-app-c
  template:
    metadata:
      name: cloud-trace-demo-c
      labels:
        app: cloud-trace-demo-app-c
    spec:
      containers:
        - name: cloud-trace-demo-container
          image: gcr.io/google_samples/cloud-trace-demo-opentelemetry:latest
          imagePullPolicy: "Always"
          command:
            - python
          args:
            - app.py
          ports:
            - containerPort: 8090
          env:
            - name: PORT
              value: "8090"
            - name: KEYWORD
              value: "Hello, I am service C"

---
apiVersion: v1
kind: Service
metadata:
  name: cloud-trace-demo-c
spec:
  selector:
    app: cloud-trace-demo-app-c
  ports:
    - protocol: TCP
      port: 8090
      targetPort: 8090
  type: ClusterIP
```
