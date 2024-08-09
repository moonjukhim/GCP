6. Task 6. Deploy the Gateway and HTTPRoutes

대문자 Gateway로 바꿔서 실행해야 함!

```bash
# kubectl get gateway external-http -o=jsonpath="{.status.addresses[0].value}" --context gke-west-1 --namespace store | xargs echo -e
kubectl get Gateway --namespace store
kubectl get Gateway external-http -o=jsonpath="{.status.addresses[0].value}" --context gke-west-1 --namespace store | xargs echo -e
```
