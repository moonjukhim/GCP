##### Task 1. Preparation

```bash
# # install_quickstart.sh
# # HBase shell 사용을 위해 압축 해제
curl -f -O https://storage.googleapis.com/cloud-training/bigtable/GoogleCloudBigtable-Quickstart-0.9.5.1.zip
unzip GoogleCloudBigtable-Quickstart-0.9.5.1.zip
```

##### Task 2. Simulate traffic sensor data into Pub/Sub

```bash
# # sensor_magic.sh
#! /bin/bash
cd ~/training-data-analyst/courses/streaming/publish/
# Run sensor simulator
python3 ./send_sensor_data.py --speedFactor=60 --project $DEVSHELL_PROJECT_ID

# publisher = pubsub.PublisherClient()
# event_type = publisher.topic_path(args.project,TOPIC)
#   ...
#   publish(publisher, topic, topublish)
#   ...
```

##### Task 3. Launch dataflow pipeline

```bash
# # create_cbt.sh (BigTable 생성)
gcloud beta bigtable instances create sandiego --cluster=cpb210 --cluster-zone=$ZONE --display-name=="San Diego Freeway data" --instance-type=DEVELOPMENT
```

```bash
#!/bin/bash

if [ "$#" -lt 3 ]; then
   echo "Usage:   ./run_oncloud.sh project-name bucket-name classname [options] "
   echo "Example: ./run_oncloud.sh cloud-training-demos cloud-training-demos CurrentConditions --bigtable"
   exit
fi

# Class <-----------------------------------------
MAIN=com.google.cloud.training.dataanalyst.sandiego.$1
echo "Launching $MAIN project=$PROJECT bucket=$BUCKET $*"

mvn compile -e exec:java \
 -Dexec.mainClass=$MAIN \
      -Dexec.args="--project=$PROJECT \
      --stagingLocation=gs://$BUCKET/staging/ $* \
      --tempLocation=gs://$BUCKET/staging/ \
      --region=$REGION \
      --workerMachineType=e2-standard-2 \
      --runner=DataflowRunner"
```
