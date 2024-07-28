### Query structure

- Start a query with a fetch or other selection operation.
- Build up a query with multiple operations piped together.
- Select a subset of information with filter operations.
- Aggregate related information with group_by operations.
- Look at outliers with top and bottom operations.
- Combine multiple queries with { ; } and join operations.
- Use the value operation and functions to compute ratios and other values.

```mql
fetch k8s_container
| metric 'kubernetes.io/container/cpu/limit_utilization'
| filter (resource.cluster_name == 'CLUSTER_NAME' &&
          resource.namespace_name == 'NAMESPACE_NAME' &&
          resource.pod_name =~ 'POD_NAME')
| group_by 1m, [value_limit_utilization_max: max(value.limit_utilization)]
| {
    top 2 | value [is_default_value: false()]
  ;
    ident
  }
| outer_join true(), _
| filter is_default_value
| value drop [is_default_value]
| every 1m
| condition val(0) > 0.73 '1'
```


---

##### Example

```MQL
fetch k8s_cluster
| metric 'logging.googleapis.com/log_entry_count'
| align rate(1m)
| every 1m
| group_by [],
    [value_log_entry_count_aggregate: aggregate(value.log_entry_count)]
```

```PromQL
sum(rate(logging_googleapis_com:log_entry_count{monitored_resource="k8s_cluster"}[${__interval}]))
```