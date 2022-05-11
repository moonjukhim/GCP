```bash
#!/bin/bash
export ZONE=us-central1-a
export PROJECT_ID=$(gcloud info --format='value(config.project)')

gsutil cp gs://sureskills-ql/partner-workshops/marketing-data/*.* .

bq mk marketing_analytics_on_demand_sources

bq --location=US load --allow_quoted_newlines --skip_leading_rows 1 \
marketing_analytics_on_demand_sources.crm_customers \
./crm_customers.csv \
./crm_customers_schema.json

bq --location=US load --allow_quoted_newlines --skip_leading_rows 1 \
marketing_analytics_on_demand_sources.review \
./review.csv \
./review_schema.json

bq --location=US load --allow_quoted_newlines --skip_leading_rows 1 \
marketing_analytics_on_demand_sources.country_code_mapping \
./country_code_mapping.csv \
./country_code_mapping_schema.json

bq --location=US load --allow_quoted_newlines --skip_leading_rows 1 \
marketing_analytics_on_demand_sources.product_list \
./product_list.csv \
./product_list_schema.json

bq --location=US load --allow_quoted_newlines --skip_leading_rows 1 \
marketing_analytics_on_demand_sources.order \
./order.csv \
./order_schema.json

bq --location=US load --allow_quoted_newlines --skip_leading_rows 1 \
marketing_analytics_on_demand_sources.order_item \
./order_item.csv \
./order_item_schema.json  
```