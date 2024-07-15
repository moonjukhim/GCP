```bash
set -o errexit  # exit on error
SCRIPT_DIR=$(realpath $(dirname "$0"))
pushd $SCRIPT_DIR > /dev/null

echo ################## Set up cloud trace demo application ###########################
kubectl apply -f app/cloud-trace-demo.yaml

echo ""
echo -n "Wait for load balancer initialization complete."
for run in {1..20}
do
  sleep 5
  endpoint=`kubectl get svc cloud-trace-demo-a -ojsonpath='{.status.loadBalancer.ingress[0].ip}'`
  if [[ "$endpoint" != "" ]]; then
    break
  fi
  echo -n "."
done

echo ""
if [ -n "$endpoint" ]; then
  echo "Completed. You can access the demo at http://${endpoint}/"
else
  echo "There is a problem with the setup. Cannot determine the endpoint."
fi
popd
```
