
```bash
kubectl -n kube-system get pod kube-proxy-gke-standard-cluster-1-default-pool-13062100-3clm -o yaml
```


```yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubernetes.io/config.hash: 528b6ecda90c2d3b87b8600889ee3eec
    kubernetes.io/config.mirror: 528b6ecda90c2d3b87b8600889ee3eec
    kubernetes.io/config.seen: "2021-11-11T23:24:35.620360689Z"
    kubernetes.io/config.source: file
  creationTimestamp: "2021-11-11T23:27:05Z"
  labels:
    component: kube-proxy
    tier: node
  name: kube-proxy-gke-standard-cluster-1-default-pool-13062100-3clm
  namespace: kube-system
  ownerReferences:
  - apiVersion: v1
    controller: true
    kind: Node
    name: gke-standard-cluster-1-default-pool-13062100-3clm
    uid: d7d572e5-e0f4-4466-a792-3a9e6996efcc
  resourceVersion: "1375"
  uid: af5d7e2c-6d4c-4284-97e8-7f13b3b2e507
spec:
  containers:
  - command:
    - /bin/sh
    - -c
    - exec kube-proxy --master=https://34.71.104.106 --kubeconfig=/var/lib/kube-proxy/kubeconfig
      --cluster-cidr=10.8.0.0/14 --oom-score-adj=-998 --v=2 --feature-gates=DynamicKubeletConfig=false,RotateKubeletServerCertificate=true,ExecProbeTimeout=false
      --iptables-sync-period=1m --iptables-min-sync-period=10s --ipvs-sync-period=1m
      --ipvs-min-sync-period=10s --detect-local-mode=NodeCIDR 1>>/var/log/kube-proxy.log
      2>&1
    image: gke.gcr.io/kube-proxy-amd64:v1.20.10-gke.1600
    imagePullPolicy: IfNotPresent
    name: kube-proxy
    resources:
      requests:
        cpu: 100m
    securityContext:
      privileged: true
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /etc/ssl/certs
      name: etc-ssl-certs
      readOnly: true
    - mountPath: /usr/share/ca-certificates
      name: usr-ca-certs
      readOnly: true
    - mountPath: /var/log
      name: varlog
    - mountPath: /var/lib/kube-proxy/kubeconfig
      name: kubeconfig
    - mountPath: /run/xtables.lock
      name: iptableslock
    - mountPath: /lib/modules
      name: lib-modules
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  hostNetwork: true
  nodeName: gke-standard-cluster-1-default-pool-13062100-3clm
  preemptionPolicy: PreemptLowerPriority
  priority: 2000001000
  priorityClassName: system-node-critical
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    operator: Exists
  - effect: NoSchedule
    operator: Exists
  volumes:
  - hostPath:
      path: /usr/share/ca-certificates
      type: ""
    name: usr-ca-certs
  - hostPath:
      path: /etc/ssl/certs
      type: ""
    name: etc-ssl-certs
  - hostPath:
      path: /var/lib/kube-proxy/kubeconfig
      type: FileOrCreate
    name: kubeconfig
  - hostPath:
      path: /var/log
      type: ""
    name: varlog
  - hostPath:
      path: /run/xtables.lock
      type: FileOrCreate
    name: iptableslock
  - hostPath:
      path: /lib/modules
      type: ""
    name: lib-modules
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2021-11-11T23:24:36Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2021-11-11T23:24:40Z"
    status: "True"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2021-11-11T23:24:40Z"
    status: "True"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2021-11-11T23:24:36Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: containerd://5316c7b40f97b5600292d0867ee623ad6230999d4839d449b7d95fdb3feb0a82
    image: gke.gcr.io/kube-proxy-amd64:v1.20.10-gke.1600
    imageID: sha256:67a0fc0d597bd146b4661484f4ae3487ad37b745e373686fd1c7dd14154fcede
    lastState: {}
    name: kube-proxy
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2021-11-11T23:24:39Z"
  hostIP: 10.128.0.11
  phase: Running
  podIP: 10.128.0.11
  podIPs:
  - ip: 10.128.0.11
  qosClass: Burstable
  startTime: "2021-11-11T23:24:36Z"
```


https://speakerdeck.com/devinjeon/kubernetes-neteuweokeu-ihaehagi-2-seobiseu-gaenyeomgwa-dongjag-weonri?slide=38
https://rtfm.co.ua/en/kubernetes-service-load-balancing-kube-proxy-and-iptables/