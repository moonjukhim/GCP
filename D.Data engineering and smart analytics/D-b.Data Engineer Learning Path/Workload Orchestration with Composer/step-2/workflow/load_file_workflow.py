import os

from airflow import DAG

from airflow.utils.dates import days_ago
from airflow.models import Variable
from airflow.providers.google.cloud.operators.gcs import GCSCreateBucketOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator

# Define the DAG
dag = DAG(
    'load_file_workflow',
    catchup = False,
    start_date = days_ago(0),
    schedule_interval=None,
)


# Get the directory of the current DAG file
dag_folder = os.path.dirname(__file__)


create_bucket = GCSCreateBucketOperator(
    task_id='create_bucket',
    bucket_name=Variable.get("bucket"),
    project_id=Variable.get("project_id"),
    location='us-central1',
    storage_class='STANDARD',
    labels={'env': 'dev', 'team': 'airflow'},
    dag=dag
)


# Upload the file to GCS
upload_sample_data = LocalFilesystemToGCSOperator(
    task_id='upload_to_gcs',
    bucket='{{ var.value.bucket }}',
    dst='sample-data/events.json',
    src = os.path.join(dag_folder, 'sample-data/events.json'),
    dag=dag,
)

create_bucket >> upload_sample_data