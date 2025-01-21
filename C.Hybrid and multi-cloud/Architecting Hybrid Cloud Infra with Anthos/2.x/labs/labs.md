1. 

```text
이 랩에서는 다중 클러스터 GKE Gateway 컨트롤러를 활성화, 사용 및 배포하는 방법을 보여줍니다. 다중 클러스터 GKE Gateway 컨트롤러는 Google에서 호스팅하는 컨트롤러로, 여러 Kubernetes 클러스터 간에 트래픽을 분산하는 외부 및 내부 로드 밸런서를 프로비저닝합니다.

GKE에서 gke-l7-gxlb-mc및 gke-l7-rilb-mcGatewayClass는 HTTP 라우팅, 트래픽 분할, 트래픽 미러링, 상태 기반 장애 조치 등을 다양한 GKE 클러스터, Kubernetes 네임스페이스 및 다양한 리전에서 제공하는 멀티 클러스터 게이트웨이를 배포합니다. 멀티 클러스터 게이트웨이는 인프라 관리자가 여러 클러스터와 팀에서 애플리케이션 네트워킹을 쉽고 안전하며 확장 가능하게 관리할 수 있도록 합니다.
- multi-cluster gateway
- Multi-cluster Gateway (MCG) controller
```