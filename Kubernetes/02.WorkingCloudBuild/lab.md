# Task2. Building Containers with DockerFile and Cloud Build

```bash
nano quickstart.sh
```

qwickstart.sh 에 추가

```
#!/bin/sh
echo "Hello, world! The time is $(date)."
```

Dockerfile 생성

```bash
nano Dockerfile
```

Dockerfile 내용

```
FROM alpine
COPY quickstart.sh /
CMD ["/quickstart.sh"]
```

CloudShell에서 명령어 수행

```bash
chmod +x quickstart.sh
gcloud builds submit --tag gcr.io/${GOOGLE_CLOUD_PROJECT}/quickstart-image .
```

# Task3. Build Containers

```
git clone https://github.com/GoogleCloudPlatform/training-data-analyst
ln -s ~/training-data-analyst/courses/ak8s/v1.1 ~/ak8s
cd ~/ak8s/Cloud_Build/a
```

```
cat cloudbuild.yaml
```

cloudbuild.yaml 파일의 내용
```
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: [ 'build', '-t', 'gcr.io/$PROJECT_ID/quickstart-image', '.' ]
images:
- 'gcr.io/$PROJECT_ID/quickstart-image'
```
