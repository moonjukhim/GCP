https://www.qwiklabs.com/focuses/1044?parent=catalog&qlcampaign=win_quests
 
 
1. 쿠버네티스 클러스터에 서버(Tiller)를 설치

```bash
kubectl config current-context
kubectl cluster-info
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# Helm과 Tiller를 초기화
helm init --service-account tiller
```

2. Tiller가 동작하는지 확인

```bash
kubectl get po --namespace kube-system
helm version
```

3. 차트 설치

```bash
helm repo update
helm install stable/mysql
# root 비밀번호 가져오기
kubectl get secret --namespace default giddy-rodent-mysql -o jsonpath="{.data.mysql-root-password}" | base64 --decode; echo
kubectl run -i --tty ubuntu --image=ubuntu:16.04 --restart=Never -- bash -il
```

4. MySQL 데이터베이스에 연결

```bash
apt-get update && apt-get install mysql-client -y
mysql -h giddy-rodent-mysql -p
```