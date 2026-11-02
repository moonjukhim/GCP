# 03. Secure AI Agents

### 목표: Agent Gateway를 강제 지점으로 삼아, 에이전트가 도구를 호출하는 경로에 제로트러스트 통제를 겁니다.

##### 핵심 내용

- IAP 인가: roles/iap.egressor를 받은 워크로드 ID만 도구를 호출할 수 있습니다.
- Model Armor: 프롬프트 인젝션을 인라인으로 차단합니다.
- Sensitive Data Protection: SSN 같은 민감정보를 비식별화합니다.
- Terraform의 enable_iap_enforcement와 enable_model_armor가 정책 스위치입니다. IAP는 DRY_RUN으로 먼저 점검한 뒤 차단 모드로 전환합니다.

##### 랩 흐름

1. 환경을 준비합니다.
2. Terraform으로 VPC, PSC 네트워크 어태치먼트, Agent Gateway를 배포합니다. 보안 스위치는 꺼 둔 상태입니다.
3. Cloud Run MCP 도구와 ADK 에이전트를 배포하고, PATCH로 게이트웨이를 연결한 뒤 Agent Registry에 등록합니다. 등록은 콘솔이 아닌 REST나 gcloud로 해야 합니다.
4. IAP 정책을 적용하고 차단 모드로 전환합니다.
5. 정상 쿼리로 경로를 검증합니다. "프랑스 수도"가 Paris로 나오면 성공입니다.
6. Model Armor와 SDP를 게이트웨이에 연결합니다.
7. 공격 테스트를 합니다. 인젝션은 HTTP 403으로 막히고, SSN은 [US_SOCIAL_SECURITY_NUMBER]로 치환됩니다.
8. 정리 스크립트를 반드시 실행합니다. 게이트웨이 쿼터가 제한적이고, 삭제 후에는 앞선 진행 체크가 통과하지 않으니 체크를 먼저 끝내야 합니다.