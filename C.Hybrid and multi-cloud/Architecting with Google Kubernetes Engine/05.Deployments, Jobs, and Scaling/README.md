

```bash
# 파드 안에 여러개의 컨테이너가 있을 경우 컨테이너 이름을 지정하고 접속
kubectl exec -it my-pod sh -c my-nginx
kubectl exec -it my-pod sh -c your-nginx
```

2. 파드 내 컨테이너의 로그를 보려면 아래 명령어를 사용

```bash
# 파드 내 컨테이너의 로그를 확인
# kubectl logs -f [pod 이름] -c [컨테이너 이름]
kubectl logs -f my-pod -c my-nginx
```