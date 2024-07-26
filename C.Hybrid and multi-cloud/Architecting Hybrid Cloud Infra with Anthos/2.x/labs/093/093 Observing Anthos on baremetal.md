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

2.  Log in to Anthos Cluster

        ```yaml
        # bmctl configuration variables
        gcrKeyPath: bmctl-workspace/.sa-keys/qwiklabs-gcp-04-f2985eb5d2a3-anthos-baremetal-gcr.json
        sshPrivateKeyPath: /root/.ssh/id_rsa
        gkeConnectAgentServiceAccountKeyPath: bmctl-workspace/.sa-keys/qwiklabs-gcp-04-f2985eb5d2a3-anthos-baremetal-connect.json
        gkeConnectRegisterServiceAccountKeyPath: bmctl-workspace/.sa-keys/qwiklabs-gcp-04-f2985eb5d2a3-anthos-baremetal-register.json
        cloudOperationsServiceAccountKeyPath: bmctl-workspace/.sa-keys/qwiklabs-gcp-04-f2985eb5d2a3-anthos-baremetal-cloud-ops.json
        ---
        apiVersion: v1
        kind: Namespace
        metadata:
        name: cluster-abm-hybrid-cluster
        ---
        apiVersion: baremetal.cluster.gke.io/v1
        kind: Cluster
        metadata:
        name: abm-hybrid-cluster
        namespace: cluster-abm-hybrid-cluster
        spec:
        type: hybrid
        profile: default
        anthosBareMetalVersion: 1.15.0
        gkeConnect:
            projectID: qwiklabs-gcp-04-f2985eb5d2a3
        controlPlane:
            nodePoolSpec:
            nodes:
                - address: 10.200.0.3
        clusterNetwork:
            pods:
            cidrBlocks:
                - 192.168.0.0/16
            services:
            cidrBlocks:
                - 10.96.0.0/20
        loadBalancer:
            mode: bundled
            ports:
            controlPlaneLBPort: 443
            vips:
            controlPlaneVIP: 10.200.0.99
            ingressVIP: 10.200.0.100
            addressPools:
            - name: pool1
                addresses:
                - 10.200.0.100-10.200.0.200
        clusterOperations:
            projectID: qwiklabs-gcp-04-f2985eb5d2a3
            location: us-central1
            enableApplication: true
        storage:
            lvpNodeMounts:
            path: /mnt/localpv-disk
            storageClassName: local-disks
            lvpShare:
            path: /mnt/localpv-share
            storageClassName: local-shared
            numPVUnderSharedPath: 5
        nodeConfig:
            podDensity:
            maxPodsPerNode: 250
        ---
        # Node pools for worker nodes
        apiVersion: baremetal.cluster.gke.io/v1
        kind: NodePool
        metadata:
        name: hybrid-cluster-pool-1
        namespace: cluster-abm-hybrid-cluster
        spec:
        clusterName: abm-hybrid-cluster
        nodes:
            - address: 10.200.0.4
            - address: 10.200.0.5
        ```

        ```bash
        cat bmctl-workspace/abm-hybrid-cluster/abm-hybrid-cluster.yaml | grep disableCloudAuditLogging:
        cat bmctl-workspace/abm-hybrid-cluster/abm-hybrid-cluster.yaml | grep enableApplication:
        ```

`````

3. Observability software stack

    ```bash
    kubectl -n kube-system get pods -l "managed-by=stackdriver"

    NAME                                                        READY   STATUS    RESTARTS   AGE
    gke-metrics-agent-s97mp                                     1/1     Running   0          25m
    gke-metrics-agent-vdsdm                                     1/1     Running   0          25m
    gke-metrics-agent-xknhj                                     1/1     Running   0          25m
    kube-state-metrics-cc8987686-j7pq2                          1/1     Running   0          25m
    node-exporter-8cftz                                         1/1     Running   0          25m
    node-exporter-fl27c                                         1/1     Running   0          25m
    node-exporter-pnmm7                                         1/1     Running   0          25m
    stackdriver-log-forwarder-lgbdj                             1/1     Running   0          25m
    stackdriver-log-forwarder-ngwpc                             1/1     Running   0          25m
    stackdriver-log-forwarder-vd7gw                             1/1     Running   0          25m
    stackdriver-metadata-agent-cluster-level-5bdcb54464-hx9jt   1/1     Running   0          25m
    ```

4. Explore audit logs

- 4.1

    ```bash
    logName="projects/PROJECT_ID/logs/externalaudit.googleapis.com%2Factivity"
    resource.type="k8s_cluster"
    protoPayload.serviceName="anthosgke.googleapis.com"
    ````

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

6. Explore cluster metrics

7. Explore cluster metrics

8. Explore application metrics

9. Install Anthos Service Mesh

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


10. Explore application tracing

11. Detect and repair node problems

---

```PromQL
sum(avg_over_time(kubernetes_io:anthos_anthos_project_type{monitored_resource="k8s_cluster"}[${__interval}]))
```

```MQL
fetch istio_canonical_service
| metric 'istio.io/service/server/request_count'
| { filter (metric.response_code < 499); ident }
| group_by [metric.destination_service_namespace]
| ratio
| fraction_less_than(0.50)
| condition val() > 0.20
| window 30s # correctly sets the window to 30s
```

```MQL
fetch k8s_container::'kubernetes.io/anthos/apiserver_admission_webhook_rejection_count'

fetch k8s_container::'kubernetes.io/anthos/apiserver_admission_webhook_rejection_count'
| filter
    (metric.error_type == 'no_error'
     && metric.name == 'binaryauthorization.googleapis.com')


```

```PromQL
sum(avg_over_time(kubernetes_io:anthos_computed_cluster_health{monitored_resource="k8s_container"}[${__interval}]))
```

[Monitoring Query Language 개요](https://cloud.google.com/monitoring/mql?hl=ko)
`````
