| Metrics              | Features                                                                          | 기능 |
| -------------------- | --------------------------------------------------------------------------------- | ---- |
| Job status           | Job status (Failed, Successful), reported as an enum every 30 secs and on update. |      |
| Elapsed time         | Job elapsed time (measured in seconds), reported every 30 secs.                   |      |
| System lag           | Max lag across the entire pipeline, reported in seconds.                          |      |
| Current vCPU         | count Current # of virtual CPUs used by the job and updated on value change.      |      |
| Estimated byte count | Number of bytes processed per PCollection.                                        |      |

---

|                       |                                           |
| --------------------- | ----------------------------------------- |
| watermark             | 단순히 타임스탬프 값                      |
| PTransform            | 입력과 출력의 watermark가 있음            |
| PCollection           | 각각 watermark가 있음                     |
| PCollection watermark | 생성한 PTransform 출력의 watermark와 동일 |
