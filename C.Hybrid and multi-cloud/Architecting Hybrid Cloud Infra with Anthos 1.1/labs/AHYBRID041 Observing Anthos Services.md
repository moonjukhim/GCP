AHYBRID041 Observing Anthos Services

Setup and requirements
Task 1. Install Anthos Service Mesh with tracing enabled
Task 2. Install the microservices-demo application on the cluster
Task 3. Review Google Cloud's operations suite functionality
Task 4. Deploy a canary release that has high latency
Task 5. Define your service level objective
Task 6. Diagnose the problem
Task 7. Roll back the release and verify an improvement
Task 8. Visualize your mesh with the Anthos Service Mesh dashboard
Review
End your lab

```bash
 asmcli install \
 --project_id $PROJECT_ID \
 --cluster_name $CLUSTER_NAME \
 --cluster_location $CLUSTER_ZONE \
 --fleet_id $FLEET_PROJECT_ID \
 --output_dir $DIR_PATH \
 --managed \
 --enable_all \
 --ca mesh_ca
```
