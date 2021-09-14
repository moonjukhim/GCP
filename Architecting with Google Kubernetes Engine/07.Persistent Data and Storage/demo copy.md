1. GCE에서 Persistent Disk 생성

```bash
gcloud compute disks create --size=10GB --zone=us-central1-c gce-nfs-disk
```

2. NFS 서버 생성

```bash
kubectl apply -f 1-nfs-server.yaml
```

