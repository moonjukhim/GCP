(Introduction to loading data)[ttps://cloud.google.com/bigquery/docs/loading-data]

#### There are several ways to ingest data into BigQuery:
- Batch load 
  - Load data from Cloud Storage
  - BigQuery Data Transfer service
  - BigQuery Storage Write API
  - Other managed services
- Stream 
  - Storage Write API
  - Dataflow
  - BigQuery Connector for SAP
- Use queries to generate new data and append or overwrite the results to a table.
  - DML
  - CREATE TABLE ... AS statement
  - Save query results
- Use a third-party application or service