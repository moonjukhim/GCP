# 02. Agent Identity Foundations

## 목표: 랩 01의 GitHub PAT와 Salesforce 시크릿을 코드와 .env에서 제거하고 Auth Manager로 옮깁니다.

##### 핵심 내용

- Agent Identity는 에이전트가 누구인지를, Auth Manager는 무엇을 읽을 수 있는지를 담당합니다.
- 부여하는 역할은 roles/agentidentity.user로 같지만 대상은 다릅니다.
  - Agent Runtime: SPIFFE principal
  - Cloud Run: 서비스 계정
- 토큰 전달 방식도 도구 유형에 따라 다릅니다.
  - MCP 도구: header_provider로 헤더에 주입
  - 함수 도구: AuthenticatedFunctionTool이 credential 인자로 주입
- 자격증명을 한곳에서 교체·폐기할 수 있고, 에이전트를 재배포할 필요가 없습니다.

##### 랩 흐름

1. 환경을 준비하고 Agent Identity API를 활성화합니다.
2. GitHub용 API key auth provider를 만듭니다.
3. GitHub 에이전트를 리팩터링하고 deploy_with_identity.sh로 배포합니다. agents-cli --agent-identity는 현재 버그가 있어 쓰지 않습니다.
4. SPIFFE principal에 권한을 주고 테스트합니다.
5. Salesforce용 2LO auth provider를 만듭니다.
6. Salesforce 에이전트에서 authenticate()를 제거하고 REST 주소를 My Domain에서 만들도록 수정합니다. Auth Manager가 instance_url을 돌려주지 않기 때문입니다.
7. Cloud Run에 재배포하고 서비스 계정에 권한을 준 뒤 End-to-End로 검증합니다.