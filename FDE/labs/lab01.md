# 01. Build Enterprise Agents

### 목표: 프로덕션 오류를 조사하는 Code Assist 시스템을 구축합니다. 프레임워크와 런타임이 달라도 A2A로 하나처럼 동작합니다.

##### 핵심 내용
- "스페셜리스트는 URL에 있는 agent card일 뿐"이라는 것이 핵심 개념입니다. 그래서 프레임워크와 런타임을 자유롭게 섞을 수 있습니다.
- 인증은 대상 런타임마다 다릅니다.
  - Agent Runtime: OAuth access token
  - 비공개 Cloud Run: audience가 지정된 ID token과 roles/run.invoker
  - 공개 GKE LB: 토큰 불필요
- 401은 토큰 누락, 403은 토큰은 유효하지만 권한 부족입니다.
- A2A 버전 불일치가 흔한 문제입니다. ADK는 a2a-sdk 0.3 클라이언트를 쓰므로, 1.x 서버는 0.3 호환 card도 함께 제공해야 합니다.
- RemoteA2aAgent는 출력이 캡처되지 않으므로 callback으로 응답을 state에 복사합니다. JoinNode는 모든 분기를 기다리는 동기화 지점입니다.

##### 랩 흐름

1. 사전 준비: Salesforce Developer 계정을 만들고 문서를 업로드합니다.
2. 환경 설정: agents-cli를 설치하고 Vertex AI Search 데이터스토어를 만듭니다.
3. github_agent: ADK + MCP로 만들어 Agent Runtime에 배포합니다.
4. stackexchange_agent: LangGraph + a2a-sdk로 만들어 Cloud Run에 배포합니다.
5. bq-agent: Antigravity 프롬프트로 생성해 GKE에 배포합니다. BigQuery 벡터 검색을 쓰며, 쿼리와 저장 데이터의 임베딩 모델이 같아야 합니다.
6. 루트 에이전트: ADK 2.0 Workflow를 query_extractor → 스페셜리스트 5개 병렬 → merge → synthesizer로 구성하고 로컬에서 테스트합니다.
7. 루트 배포: IAM을 부여하고 Gemini Enterprise에 등록합니다. 로컬은 사용자 자격증명, 배포 후는 서비스 계정으로 호출하므로 403이 납니다.
8. salesforce_agent: 2-legged OAuth로 Cloud Run에 배포하고 루트에 연결합니다.
9. 장기 메모리: Vertex AI Memory Bank를 붙이고, 사용자 ID를 A2A로 전달해 대화가 바뀌어도 기억하게 합니다.