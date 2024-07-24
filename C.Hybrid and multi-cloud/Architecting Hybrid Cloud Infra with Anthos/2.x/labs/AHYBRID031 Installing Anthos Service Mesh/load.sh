#!/bin/bash -x

export HOSTNAME=$(hostname)
export PROJECT_ID=$(gcloud config get-value project)
export LAB_DIR="/setup"

# export KUBECONFIG=/.kube/config

gcloud config set project $PROJECT_ID
mkdir $LAB_DIR
cd $LAB_DIR
mkdir bin

function apt-get-install {
  until apt-get -q -y -o DPkg::Options::=--force-confold -o DPkg::Options::=--force-confdef install $@; do
    echo "== install of packages $@ failed, retrying =="
    sleep 5
  done
}

apt update
apt-get-install git

# revise to use google's repo once merged
git clone https://github.com/GoogleCloudPlatform/training-data-analyst.git
cd ./training-data-analyst/courses/ahybrid/v1.0/AHYBRID031
# git clone https://github.com/jwdavis/training-data-analyst.git --branch jwd-anthos-hotfixes
# cd ./training-data-analyst/courses/ahybrid/v1.0/AHYBRID031


chmod +x ../common/scripts/services.sh
../common/scripts/services.sh

source ./scripts/env.sh

chmod +x ../common/scripts/install.sh
../common/scripts/install.sh

chmod +x ../common/scripts/create_gke.sh
../common/scripts/create_gke.sh

gcloud beta runtime-config configs variables set success/${HOSTNAME} success \
  --config-name ${HOSTNAME}-config >>${PROJECT_ID}.txt
