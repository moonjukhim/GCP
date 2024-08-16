- 1.Error Issue :

```text
Workflow failed. Causes: There was a problem refreshing your credentials. Please check: 1. Dataflow API is enabled for your project. 2. Make sure both the Dataflow service account and the controller service account have sufficient permissions. If you are not specifying a controller service account, ensure the default Compute Engine service account [PROJECT_NUMBER]-compute@developer.gserviceaccount.com exists and has sufficient permissions. If you have deleted the default Compute Engine service account, you must specify a controller service account. For more information, see: https://cloud.google.com/dataflow/docs/concepts/security-and-permissions#security_and_permissions_for_pipelines_on_google_cloud_platform. , There is no cloudservices robot account for your project. Please ensure that the Dataflow API is enabled for your project.
```

--> 만약 실패할 경우, 다시 실행

- 2.AverageSpeed.java (AvgSpeed.java)

```java
// 
// ...
//
avgSpeed.apply("ToBQRow", ParDo.of(new DoFn<KV<String, Double>, TableRow>() {
      @ProcessElement
      public void processElement(ProcessContext c) throws Exception {
        TableRow row = new TableRow();
        String stationKey = c.element().getKey();
        Double speed = c.element().getValue();
        String line = Instant.now().toString() + "," + stationKey + "," + speed; // CSV
        LaneInfo info = LaneInfo.newLaneInfo(line);
        row.set("timestamp", info.getTimestamp());
        row.set("latitude", info.getLatitude());
        row.set("longitude", info.getLongitude());
        row.set("highway", info.getHighway());
        row.set("direction", info.getDirection());
        row.set("lane", info.getLane());
        row.set("speed", info.getSpeed());
        row.set("sensorId", info.getSensorKey());
        c.output(row);
      }
    })) // <<<<<< 
        .apply(BigQueryIO.writeTableRows().to(avgSpeedTable)//
            .withSchema(schema)//
            .withWriteDisposition(BigQueryIO.Write.WriteDisposition.WRITE_APPEND) // WriteDisposition.WRITE_APPEND:새 래코드 추가
            .withCreateDisposition(BigQueryIO.Write.CreateDisposition.CREATE_IF_NEEDED));
```