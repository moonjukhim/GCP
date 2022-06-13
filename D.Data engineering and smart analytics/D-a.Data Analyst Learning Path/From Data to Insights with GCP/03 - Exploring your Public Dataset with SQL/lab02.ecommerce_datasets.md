### Day 1
### Lab 02 - Explore your Ecommerce Datasets with SQL in BigQuery

### Ecommerce Datasets

- all_sessions
- all_sessions_raw


### 

```sql
#standardSQL
SELECT COUNT(*) as num_duplicate_rows, * 
FROM `data-to-insights.ecommerce.all_sessions_raw`
GROUP BY
    fullVisitorId, channelGrouping, time, country, city, totalTransactionRevenue, transactions, timeOnSite, pageviews, sessionQualityDim, date, visitId, type, productRefundAmount, productQuantity, productPrice, productRevenue, productSKU, v2ProductName, v2ProductCategory, productVariant, currencyCode, itemQuantity, itemRevenue, transactionRevenue, transactionId, pageTitle, searchKeyword, pagePathLevel1, eCommerceAction_type, eCommerceAction_step, eCommerceAction_option
HAVING num_duplicate_rows > 1;
```