### Table of Contents
---
#### Exploring, Transforming, and Visualizing Data
1. Introduction to Google Cloud Platform 
2. Analyzing Large Datasets with BigQuery (Lab: BigQuery Basics)
3. Exploring your Public Dataset with SQL (Lab: Explore your Ecommerce Dataset with SQL in Google BigQuery)
4. Cleaning and Transforming your Data with Cloud Dataprep (Lab: Creating a Data Transformation Pipeline with Cloud Dataprep)
5. Visualizing Insights and Creating Scheduled Queries (Lab: How to Build a BI Dashboard Using Google Data Studio and BigQuery)
---
#### Creating and Optimizing your Data Warehouse
6. Storing and Ingesting new Datasets

lab
###### 5. Lab: Ingesting New Datasets into BigQuery
###### 6. Lab: Troubleshooting and Solving Data Join Pitfalls
###### 7. Lab: Creating Date-Partitioned Tables in BigQuery
###### 8. Lab: Schema Design for Performance: Arrays and Structs in BigQuery
---
#### Machine Learning for Structured and Unstructured Datasets
###### 9. Lab: Predict Visitor Purchases with a Classification Model with BigQuery ML
###### 10. Lab: Extract, Analyze, and Translate Text from Images with the Cloud ML APIs
###### 11. Lab: Classify Images of Clouds in the Cloud with AutoML Vision

---

Table of Contents
Lab 1: BigQuery Basics
Setup and requirements
Query a public dataset
Create a custom table
Create a dataset
Load the data into a new table
Query the table
---------
Lab 2: Exploring Your Ecommerce Dataset with SQL in Google BigQuery
Pin the Lab Project in BigQuery
Explore ecommerce data and identify duplicate records
Write basic SQL on ecommerce data
---------
Lab 3: Creating a Data Transformation Pipeline with Cloud Dataprep
Task 1. Creating a BigQuery Dataset
Task 2. Opening Cloud Dataprep
Task 3. Connecting BigQuery data to Cloud Dataprep
Task 4. Exploring ecommerce data fields with a UI
Task 5. Cleaning the data
Task 6. Enriching the data
Task 7. Running and scheduling Cloud Dataprep jobs to BigQuery
---------
Lab 4: How to Build a BI Dashboard Using Google Data Studio and BigQuery
Solution overview
Uploading queryable data
Create a reports dataset in BigQuery
Query the dashboard data
Scheduling queries in BigQuery
Create new data sources in Data Studio
Create a new report in Data Studio
---------
Lab 5: Ingesting New Datasets into BigQuery
Create a new dataset to store tables
Ingest a new Dataset from a CSV
Ingest data from Google Cloud Storage
Ingest a new dataset from a Google Spreadsheet
Saving Data to Google Sheets
External table performance and data quality considerations
---------
Lab 6: Troubleshooting and Solving Data Join Pitfalls
Create a new dataset to store your tables
Pin the Lab Project in BigQuery
Examine the fields
Identify a key field in your ecommerce dataset
Pitfall: non-unique key
Join pitfall solution: use distinct SKUs before joining
---------
Lab 7: Creating Date-Partitioned Tables in BigQuery
Create a new dataset
Creating tables with date partitions
View data processed with a partitioned table
Creating an auto-expiring partitioned table
Your turn: Create a Partitioned Table
Confirm the oldest partition_age is at or below 60 days
---------
Lab 8: Schema Design for Performance: Arrays and Structs in BigQuery
Create a new dataset to store our tables
Practice working with Arrays in SQL
Creating your own arrays with ARRAY_AGG()
Querying datasets that already have ARRAYs
Introduction to STRUCTs
Practice with STRUCTs and ARRAYs
Working with STRUCTs
Unpacking ARRAYs with UNNEST( )
Filtering within ARRAY values
---------
Lab 9: Predict Visitor Purchases with a Classification Model with BigQuery ML
Explore ecommerce data
Identify an objective
Select features and create your training dataset
Create a BigQuery dataset to store models
Select a BQML model type and specify options
Evaluate classification model performance
Improve model performance with Feature Engineering
Predict which new visitors will come back and purchase
Results
---------
Lab 10: Extract, Analyze, and Translate Text from Images with the Cloud ML APIs
Create an API Key
Upload an image to a cloud storage bucket
Create your Vision API request
Call the Vision API's text detection method
Sending text from the image to the Translation API
Analyzing the image's text with the Natural Language API
---------
Lab 11: Classify Images of Clouds in the Cloud with AutoML Vision
Setup
Set up AutoML Vision
Upload training images to Google Cloud Storage
Create a dataset
Inspect images
Train your model
Evaluate your model
Generate predictions
Congratulations!
End your lab