### AHYBRID093: Observing Anthos clusters on bare metal

1. Explore the pre-created environment
2. Log in to your Anthos cluster
3. Understand installed observability software stack
4. Explore audit logs
5. Explore cluster logs
6. Explore application logs
7. Explore cluster metrics
8. Explore application metrics
9. Install Anthos Service Mesh
10. Explore application tracing
11. Detect and repair node problems
12. Troubleshooting

---

4. Explore audit logs

- 4.1

```bash
logName="projects/PROJECT_ID/logs/externalaudit.googleapis.com%2Factivity"
  resource.type="k8s_cluster"
  protoPayload.serviceName="anthosgke.googleapis.com"
```

5. Install Anthos Service Mesh

```bash
cat <<'EOF' > cloud-trace.yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
spec:
    meshConfig:
        enableTracing: true
    values:
            global:
                proxy:
                        tracer: stackdriver
EOF
```

```bash
curl https://storage.googleapis.com/csm-artifacts/asm/asmcli_1.15 > asmcli
chmod +x asmcli
```

```bash
export PROJECT_ID=
export CLUSTER_NAME=
export CLUSTER_LOCATION=
```

```bash
export FLEET_PROJECT_ID=$(gcloud config get-value project)
./asmcli install \
    --kubeconfig ./bmctl-workspace/abm-hybrid-cluster/abm-hybrid-cluster-kubeconfig \
    --fleet_id $FLEET_PROJECT_ID \
    --output_dir . \
    --platform multicloud \
    --enable_all \
    --ca mesh_ca \
    --custom_overlay cloud-trace.yaml
```
