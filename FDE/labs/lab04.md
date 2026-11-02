# 04. Observe and Secure a Multi-Agent System

## 목표: 실행 중인 시스템을 보이게 만들고, 보안 태세를 점검합니다.

##### 핵심 내용
- 관측과 보안은 트레이스 데이터 + App Hub + Agent Registry라는 같은 기반 위에 있습니다.
- 추적에는 세 가지가 필요합니다: 계측 라이브러리, exporter 설정, 내보내기 권한(roles/telemetry.tracesWriter).
- 런타임이 발견 경로를 결정합니다. Agent Runtime은 자동이고, Cloud Run 에이전트와 MCP 서버는 직접 등록해야 합니다.

##### 랩 흐름

1. 환경을 준비하고 에이전트가 있는지 확인한 뒤 관측·발견 API를 활성화합니다.
2. Cloud Run 서비스 계정에 트레이스 권한을 주고, 트래픽을 만들어 Trace Explorer에서 call_llm 등의 span을 확인합니다.
3. Agent Runtime 에이전트가 자동 발견됐는지 확인합니다.
4. Salesforce 에이전트의 agent card를 내려받아 Agent Registry에 등록합니다.
5. GitHub MCP 서버를 등록합니다.
6. Agent Topology 그래프를 확인합니다. 배치 처리라 랩 중에 완성되지 않을 수 있고, 이는 예상된 동작입니다.
7. 서비스 계정에 roles/editor를 일부러 부여합니다.
8. AI Protection에서 발견하고 Policy Analyzer로 범위를 증명한 뒤 제거해 최소 권한으로 되돌립니다.
9. (선택) Threat Detection으로 런타임 공격을 시뮬레이션합니다.