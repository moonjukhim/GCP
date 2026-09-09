# To help with delays, like retry delay
from datetime import timedelta
# To determine the path to the DAG folder
import os 
# We'll use this to help make a unique table name
import uuid

# DAG object definition
from airflow import DAG
# To set the start date of the DAG
from airflow.utils.dates import days_ago
# To access variables defined in the Airflow UI
from airflow.models import Variable
# PythonOperator to execute Python callables
from airflow.operators.python_operator import PythonOperator
# Sensor to check for the existence of objects in Google Cloud Storage 
from airflow.providers.google.cloud.sensors.gcs import GCSObjectExistenceSensor
# Operator to run Beam pipelines on Dataflow
from airflow.providers.apache.beam.operators.beam import BeamRunPythonPipelineOperator
# Enum for specifying the Beam runner type
from airflow.providers.apache.beam.hooks.beam import BeamRunnerType
# Operator to export data from BigQuery to Cloud Storage
from airflow.providers.google.cloud.transfers.bigquery_to_gcs import BigQueryToGCSOperator
# Configuration class for Dataflow pipelines
from airflow.providers.google.cloud.operators.dataflow import DataflowConfiguration
# Sensor to monitor the status of Dataflow jobs
from airflow.providers.google.cloud.sensors.dataflow import DataflowJobStatusSensor
# Enum for Dataflow job states
from airflow.providers.google.cloud.hooks.dataflow import DataflowJobStatus
# Operator to delete objects from GCS
from airflow.providers.google.cloud.operators.gcs import GCSDeleteObjectsOperator
# Operator to delete tables from BigQuery
from airflow.providers.google.cloud.operators.bigquery import BigQueryDeleteTableOperator

# Client library for interacting with the Dataflow API
from google.cloud import dataflow_v1beta3


# Get the directory of the current DAG file
dag_folder = os.path.dirname(__file__)


default_args = {
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}


# Define the DAG
dag = DAG(
    'file_ingest_workflow',
    default_args = default_args,
    catchup = False,
    start_date = days_ago(0),
    schedule_interval=None,
)


