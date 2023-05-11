## 워크로드 아이덴티티 사용 설정

````bash
PROJECT_ID=$(gcloud config get-value project)
gcloud container clusters create standard-cluster1 \
    --region=us-central1 \
    --workload-pool=$PROJECT_ID.svc.id.goog \
    --num-nodes 1


gcloud container clusters get-credentials standard-cluster1 \
    --region=us-central1


kubectl create namespace workload


kubectl create serviceaccount ksa \
    --namespace workload



gcloud iam service-accounts create gsa-account \
    --project=$PROJECT_ID



gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member "serviceAccount:gsa-account@$PROJECT_ID.iam.gserviceaccount.com" \
    --role "roles/cloudsql.admin"



gcloud iam service-accounts add-iam-policy-binding gsa-account@$PROJECT_ID.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:$PROJECT_ID.svc.id.goog[workload/ksa]"


kubectl annotate serviceaccount ksa \
    --namespace workload \
    iam.gke.io/gcp-service-account=gsa-account@$PROJECT_ID.iam.gserviceaccount.com



gcloud sql instances create sql-instance --tier=db-n1-standard-2 --region=us-central1


```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  namespace: workload
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      serviceAccountName: ksa
      containers:
        - name: web
          image: gcr.io/cloud-marketplace/google/wordpress:5.9
          ports:
            - containerPort: 80
          env:
            - name: WORDPRESS_DB_HOST
              value: 127.0.0.1:3306
            # These secrets are required to start the pod.
            # [START cloudsql_secrets]
            #- name: WORDPRESS_DB_USER
            #  valueFrom:
            #    secretKeyRef:
            #      name: sql-credentials
            #      key: username
            #- name: WORDPRESS_DB_PASSWORD
            #  valueFrom:
            #    secretKeyRef:
            #      name: sql-credentials
            #      key: password
            # [END cloudsql_secrets]
        # Change <INSTANCE_CONNECTION_NAME> here to include your Google Cloud
        # project, the region of your Cloud SQL instance and the name
        # of your Cloud SQL instance. The format is
        # $PROJECT:$REGION:$INSTANCE
        # [START proxy_container]
        - name: cloudsql-proxy
          image: gcr.io/cloudsql-docker/gce-proxy:latest
          command: ["/cloud_sql_proxy",
                    "-instances=qwiklabs-gcp-01-ea900c5fdbb3:us-central1:sql-instance=tcp:3306"]
          # [START cloudsql_security_context]
          securityContext:
            runAsUser: 2  # non-root user
            allowPrivilegeEscalation: false
          # [END cloudsql_security_context]

        # [END proxy_container]
---
apiVersion: "v1"
kind: "Service"
metadata:
  name: "wordpress-service"
  namespace: "workload"
  labels:
    app: "wordpress"
spec:
  ports:
  - protocol: "TCP"
    port: 80
  selector:
    app: "wordpress"
  type: "LoadBalancer"
  loadBalancerIP: ""
````
