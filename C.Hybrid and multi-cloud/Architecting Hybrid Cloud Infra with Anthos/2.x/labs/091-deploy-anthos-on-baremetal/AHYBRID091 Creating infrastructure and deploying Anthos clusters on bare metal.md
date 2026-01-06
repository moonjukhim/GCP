### Creating infrastructure and deploying Anthos clusters on bare metal

1. Confirm your network setup
2. Create your server infrastructure
3. 


#### Task 1. Confirm your network setup

#### Task 2. Create your server infrastructure

1. Initialize

```bash
# configure environment variables with project id and zone
export PROJECT_ID=$(gcloud config get-value project)
export ZONE=us-central1-a

# configure environment variable for machine type
WS_MACHINE_TYPE=n1-standard-4
CLUSTER_MACHINE_TYPE=n1-standard-4

# configure environment variables for server names
VM_PREFIX=abm
VM_WS=$VM_PREFIX-ws
VM_A_CP1=$VM_PREFIX-admin-cp1
VM_U_CP1=$VM_PREFIX-user-cp1
VM_U_W1=$VM_PREFIX-user-w1

# create arrays of the server names
declare -a VMs=("$VM_WS" "$VM_A_CP1" "$VM_U_CP1" "$VM_U_W1")
declare -a ADMIN_CP_VMs=("$VM_A_CP1")
declare -a USER_CP_VMs=("$VM_U_CP1")
declare -a USER_WORKER_VMs=("$VM_U_W1")
declare -a LB_VMs=("$VM_A_CP1" "$VM_U_CP1")

# create an array to hold the IP addresses of the servers
declare -a IPs=()
```

2. Build the GCE VM

```bash
gcloud compute instances create $VM_WS \
    --image-family=ubuntu-2004-lts \
    --image-project=ubuntu-os-cloud \
    --zone=${ZONE} \
    --boot-disk-size 256G \
    --boot-disk-type pd-ssd \
    --can-ip-forward \
    --network anthos-network \
    --subnet us-central1-subnet \
    --scopes cloud-platform \
    --machine-type $WS_MACHINE_TYPE \
    --metadata=os-login=FALSE \
    --verbosity=error
IP=$(gcloud compute instances describe $VM_WS --zone ${ZONE} \
    --format='get(networkInterfaces[0].networkIP)')
IPs+=("$IP")
```

```bash
 # loop through the array of server names
 # for each server name, create a GCE VM
 # add the new VM IP address to IP array
 for vm in "${VMs[@]:1}"
 do
     gcloud compute instances create $vm \
         --image-family=ubuntu-2004-lts \
         --image-project=ubuntu-os-cloud \
         --zone=${ZONE} \
         --boot-disk-size 256G \
         --boot-disk-type pd-standard \
         --can-ip-forward \
         --network anthos-network \
         --subnet us-central1-subnet \
         --min-cpu-platform "Intel Haswell" \
         --scopes cloud-platform \
         --machine-type $CLUSTER_MACHINE_TYPE \
         --metadata=os-login=FALSE \
         --verbosity=error
     IP=$(gcloud compute instances describe $vm --zone ${ZONE} \
         --format='get(networkInterfaces[0].networkIP)')
     IPs+=("$IP")
 done
```

assing appropriate network tags

```bash
 for vm in "${ADMIN_CP_VMs[@]}"
 do
     gcloud compute instances add-tags $vm --zone ${ZONE} \
         --tags="cp,admin"
 done
 for vm in "${USER_CP_VMs[@]}"
 do
     gcloud compute instances add-tags $vm --zone ${ZONE} \
         --tags="cp,user"
 done
 for vm in "${USER_WORKER_VMs[@]}"
 do
     gcloud compute instances add-tags $vm --zone ${ZONE} \
         --tags="worker,user"
 done
 for vm in "${LB_VMs[@]}"
 do
     gcloud compute instances add-tags $vm --zone ${ZONE} \
         --tags="lb"
 done
 for vm in "${VMs[@]}"
 do
     gcloud compute instances add-tags $vm --zone ${ZONE} \
         --tags="vxlan"
 done
```

- Configure the required IAM Roles for the Compute Engine VMs
- Configure the server OS as required for bare metal Anthos
    - diable UFW

```bash
for vm in "${VMs[@]}"
do
    echo "Disabling UFW on $vm"
    gcloud compute ssh root@$vm --zone ${ZONE} --tunnel-through-iap  << EOF
        sudo ufw disable
EOF
done
```

- configure vxlan

```bash
i=2
for vm in "${VMs[@]}"
do
    gcloud compute ssh root@$vm --zone ${ZONE} --tunnel-through-iap << EOF
        # update package list on VM
        apt-get -qq update > /dev/null
        apt-get -qq install -y jq > /dev/null
        # print executed commands to terminal
        set -x
        # create new vxlan configuration
        ip link add vxlan0 type vxlan id 42 dev ens4 dstport 4789
        current_ip=\$(ip --json a show dev ens4 | jq '.[0].addr_info[0].local' -r)
        echo "VM IP address is: \$current_ip"
        for ip in ${IPs[@]}; do
            if [ "\$ip" != "\$current_ip" ]; then
                bridge fdb append to 00:00:00:00:00:00 dst \$ip dev vxlan0
            fi
        done
        ip addr add 10.200.0.$i/24 dev vxlan0
        ip link set up dev vxlan0
EOF
    i=$((i+1))
done
```

check vxlan Ips

```bash
i=2
for vm in "${VMs[@]}";
do
    echo $vm;
    gcloud compute ssh root@$vm --zone ${ZONE} --tunnel-through-iap --command="hostname -I";
    i=$((i+1));
done
```

- configure network firewall rule

```bash
gcloud compute firewall-rules create abm-allow-cp \
    --network="anthos-network" \
    --allow="UDP:6081,TCP:22,TCP:6444,TCP:2379-2380,TCP:10250-10252,TCP:4240" \
    --source-ranges="10.0.0.0/8" \
    --target-tags="cp"

gcloud compute firewall-rules create abm-allow-worker \
    --network="anthos-network" \
    --allow="UDP:6081,TCP:22,TCP:10250,TCP:30000-32767,TCP:4240" \
    --source-ranges="10.0.0.0/8" \
    --target-tags="worker"

gcloud compute firewall-rules create abm-allow-lb \
    --network="anthos-network" \
    --allow="UDP:6081,TCP:22,TCP:443,TCP:7946,UDP:7496,TCP:4240" \
    --source-ranges="10.0.0.0/8" \
    --target-tags="lb"
gcloud compute firewall-rules create allow-gfe-to-lb \
    --network="anthos-network" \
    --allow="TCP:443" \
    --source-ranges="10.0.0.0/8,130.211.0.0/22,35.191.0.0/16" \
    --target-tags="lb"

gcloud compute firewall-rules create abm-allow-multi \
    --network="anthos-network" \
    --allow="TCP:22,TCP:443" \
    --source-tags="admin" \
    --target-tags="user"
```

#### 3. Set up the admin workstation

```bash
 export PROJECT_ID=$(gcloud config get-value project)
 export ZONE=us-central1-a
 # configure environment variables for server names
 VM_PREFIX=abm
 VM_WS=$VM_PREFIX-ws
 VM_A_CP1=$VM_PREFIX-admin-cp1
 VM_U_CP1=$VM_PREFIX-user-cp1
 VM_U_W1=$VM_PREFIX-user-w1
 # create arrays of the server names
 declare -a VMs=("$VM_WS" "$VM_A_CP1" "$VM_U_CP1" "$VM_U_W1")
 declare -a ADMIN_CP_VMs=("$VM_A_CP1")
 declare -a USER_CP_VMs=("$VM_U_CP1")
 declare -a USER_WORKER_VMs=("$VM_U_W1")
 declare -a LB_VMs=("$VM_A_CP1" "$VM_U_CP1")
```

connect to admin workstation

```bash
# enable ssh-agent
eval `ssh-agent`
# add your identity
ssh-add ~/.ssh/google_compute_engine
# ssh into the admin workstation with authentication forwarding
gcloud compute ssh --ssh-flag="-A" root@$VM_WS \
    --zone ${ZONE} \
    --tunnel-through-iap
```

```bash
export PROJECT_ID=$(gcloud config get-value project)
```

```bash
# remove the GCE-specific version of the SDK
snap remove google-cloud-sdk
# install the SDK as you would on a non-GCE server
curl https://sdk.cloud.google.com | bash
```

restart shell

```bash
# restart your shell
exec -l $SHELL
# Create keys for a service account with the same permissions as the lab user
gcloud iam service-accounts keys create installer.json \
  --iam-account=${PROJECT_ID}@${PROJECT_ID}.iam.gserviceaccount.com
# set the Application Default Credentials
export GOOGLE_APPLICATION_CREDENTIALS=~/installer.json
```

```bash
gcloud components install kubectl
kubectl config view
```

bmctl

```bash
mkdir baremetal && cd baremetal
gsutil cp gs://anthos-baremetal-release/bmctl/1.12.0/linux-amd64/bmctl .
chmod a+x bmctl
mv bmctl /usr/local/sbin/
bmctl version
```

docker

```bash
cd ~
echo "Installing docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
docker version
```

configure server to allow SSH from admin workstation

```bash
ssh-keygen -t rsa
```

```bash
VM_PREFIX=abm
VM_WS=$VM_PREFIX-ws
VM_A_CP1=$VM_PREFIX-admin-cp1
VM_U_CP1=$VM_PREFIX-user-cp1
VM_U_W1=$VM_PREFIX-user-w1
declare -a VMs=("$VM_WS" "$VM_A_CP1" "$VM_U_CP1" "$VM_U_W1")
for vm in "${VMs[@]:1}"
do
    ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub root@$vm
done
```

```bash
VM_PREFIX=abm
VM_WS=$VM_PREFIX-ws
VM_A_CP1=$VM_PREFIX-admin-cp1
VM_U_CP1=$VM_PREFIX-user-cp1
VM_U_W1=$VM_PREFIX-user-w1
declare -a VMs=("$VM_WS" "$VM_A_CP1" "$VM_U_CP1" "$VM_U_W1")
for vm in "${VMs[@]:1}"
do
    ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub root@$vm
done
```

```bash
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens
```

#### Task 4. Create your admin cluster

Create the config file

```bash
 # configure environment variables
 export ZONE=us-central1-a
 export SSH_PRIVATE_KEY=/root/.ssh/id_rsa
 export LB_CONTROLL_PLANE_NODE=10.200.0.3
 export LB_CONTROLL_PLANE_VIP=10.200.0.98
 # create additional arrays of the server names
 declare -a ADMIN_CP_VMs=("$VM_A_CP1")
 declare -a USER_CP_VMs=("$VM_U_CP1")
 declare -a USER_WORKER_VMs=("$VM_U_W1")
 declare -a LB_VMs=("$VM_A_CP1" "$VM_U_CP1")
```

```bash
cd ~/baremetal
bmctl create config -c abm-admin-cluster   --enable-apis --create-service-accounts --project-id=$PROJECT_ID
```

```bash
ls bmctl-workspace/.sa-keys/
```
