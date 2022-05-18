#! /bin/bash

bq mk --dataset $DEVSHELL_PROJECT_ID:demos

bq load --skip_leading_rows=1 --source_format=CSV demos.average_speeds gs://cloud-training/gcpdei/results-20180608-102960.csv timestamp:TIMESTAMP,latitude:FLOAT,longitude:FLOAT,highway:STRING,direction:STRING,lane:INTEGER,speed:FLOAT,sensorId:STRING
bq load --skip_leading_rows=1 --source_format=CSV demos.current_conditions gs://cloud-training/gcpdei/results-20180608-102960.csv timestamp:TIMESTAMP,latitude:FLOAT,longitude:FLOAT,highway:STRING,direction:STRING,lane:INTEGER,speed:FLOAT,sensorId:STRING
