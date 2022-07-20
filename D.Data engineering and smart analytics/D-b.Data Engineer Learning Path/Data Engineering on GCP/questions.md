### BigQuery

1. with 절과 성능 관련
    - [BigQuery: WITH Clause](https://flowygo.com/en/blog/bigquery-with-clause/)

2. 파티션 만료 시간 설정
    - [파티션 만료 시간 설정](https://cloud.google.com/bigquery/docs/managing-partitioned-tables#partition-expiration)

3. "BigQuery has a fair scheduler"라면 혹시 Capacity Scheduler로도 동작할 수 있나요? 
    - fair scheduler만 존재

4. BigQuery의 데이터 셋 별로 권한 확인
    - INFORMATION_SCHEMA 에서 조회 
  
  ```sql
  SELECT *
  FROM mycompany.`region-us`.INFORMATION_SCHEMA.OBJECT_PRIVILEGES
  WHERE object_name = "mydataset"
  ```

5. BigQuery Reservation 할당 단위
    - [프로젝트, 폴더 또는 조직 하나 이상을 예약에 할당하고 사용](https://cloud.google.com/bigquery/docs/reservations-intro?hl=ko)

### Data Fusion

1. 실행된 파이프라인의 일부 property를 변경할 수 있을까요?
    - [재사용 가능한 파이프라인 만들기](https://cloud.google.com/data-fusion/docs/tutorials/reusable-pipeline?hl=ko)

