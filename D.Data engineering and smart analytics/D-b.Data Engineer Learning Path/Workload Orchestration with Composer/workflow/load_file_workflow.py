import os
from datetime import datetime

from airflow import DAG
from airflow.models import Variable

from airflow.providers.google.cloud.operators.gcs import GCSCreateBucketOperator
from airflow.providers.google.cloud.transfers.local_to_gcs import LocalFilesystemToGCSOperator


# DAG 정의 (권장 방식)
with DAG(
    dag_id="load_file_workflow",
    start_date=datetime(2024, 1, 1),  # ✅ 안정적인 고정값
    schedule=None,
    catchup=False,
) as dag:

    # 변수 가져오기 (한 번만)
    BUCKET_NAME = Variable.get("bucket")
    PROJECT_ID = Variable.get("project_id")

    # ✅ Composer에서 실제 파일 위치
    LOCAL_FILE_PATH = "/home/airflow/gcs/data/sample-data/events.json"

    # 1. Bucket 생성
    create_bucket = GCSCreateBucketOperator(
        task_id="create_bucket",
        bucket_name=BUCKET_NAME,
        project_id=PROJECT_ID,
        location="us-central1",
        storage_class="STANDARD",
        labels={"env": "dev", "team": "airflow"},
    )

    # 2. 파일 업로드
    upload_sample_data = LocalFilesystemToGCSOperator(
        task_id="upload_to_gcs",
        bucket=BUCKET_NAME,  # ✅ 변수 통일
        src=LOCAL_FILE_PATH,  # ✅ Composer 경로 사용
        dst="sample-data/events.json",
    )

    create_bucket >> upload_sample_data