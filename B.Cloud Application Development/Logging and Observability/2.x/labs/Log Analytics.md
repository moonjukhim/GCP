```sql
SELECT
 TIMESTAMP,
 JSON_VALUE(resource.labels.container_name) AS container,
 json_payload
FROM
  `qwiklabs-gcp-02-bfbb9fe0bcd3.global.day2ops._AllLogs`
WHERE
  json_payload IS NOT NULL
ORDER BY
 1 DESC
LIMIT
 50
```