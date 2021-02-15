# Deploying Jobs on Google Kubernetes Engine

### Task1. Job 매니페스트 생성과 배포

### Task2. CronJob 매니페스트 정의 및 배포
---

### Task1. Define and deploy a Job manifest

1.1 GKE에 접속

```bash
export my_zone=us-central1-a
export my_cluster=standard-cluster-1

source <(kubectl completion bash)

gcloud container clusters get-credentials $my_cluster --zone $my_zone
```

Repositories

```
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Jobs_CronJobs
```

Job 매니페스트

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  # Unique key of the Job instance
  name: example-job
spec:
  template:
    metadata:
      name: example-job
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl"]
        args: ["-Mbignum=bpi", "-wle", "print bpi(2000)"]
      # Do not restart containers after they exit
      restartPolicy: Never
```

잡 생성

```bash
kubectl apply -f example-job.yaml
```

```
kubectl describe job example-job
```

잡 정리

```
kubectl get jobs
kubectl logs [POD-NAME]
kubectl delete job example-job
```

# Task2. CronJob 매니페스트 정의 및 배포

매니페스트 파일

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo "Hello, World!"
          restartPolicy: OnFailure
```

잡 생성

```
kubectl apply -f example-cronjob.yaml
```

```
kubectl get jobs
kubectl describe job [job_name]
kubectl logs [POD-NAME]
kubectl get jobs
kubectl delete cronjob hello
```
