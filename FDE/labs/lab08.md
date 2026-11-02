# 08. Add Google Drive with Sensitive Data Protection to Gemini Enterprise

## 목표: Drive를 Gemini Enterprise에 연결하고, 라벨과 민감정보 기준으로 접근을 차단합니다.

##### 핵심 내용
- Drive 커넥터는 Federated search 방식입니다.
- SDP는 내용뿐 아니라 Drive 파일 라벨(File Label infoType)로도 통제할 수 있습니다.
- 정책은 커넥터, Assistant, Gemini Notebook에 각각 적용해야 합니다.

##### 랩 흐름
1. cymbal-ge-app을 만들고 Google Identity를 설정합니다.
2. cymbal-gdrive-connector를 구성하고 앱에 연결합니다. Active 상태까지 최대 10분 걸립니다.
3. 샘플 문서 3개를 만들고 조회와 요약을 테스트합니다.
4. Cymbal_QuantumLedger에 Cymbal Confidential 라벨을 붙입니다.
5. cepf-drive-policy를 만듭니다. File Label과 신용카드 infoType을 넣고, Allow를 제거한 뒤 Block을 설정합니다.
6. 정책을 커넥터에 붙이고 Discovery Engine Service Agent에 DLP User 역할을 줍니다.
7. 기밀 문서는 차단되고 공개 문서는 정상 응답하는지 확인합니다.
8. Assistant와 Notebook에 정책을 적용하고, 파일 추가와 신용카드 데이터 소스가 차단되는지 확인합니다.

---

##### 실습 전 주의사항

- 랩 간 의존성: 01·02·04는 같은 GitHub PAT와 Salesforce 자격증명을 다시 씁니다. 로컬에 안전하게 보관해 두세요.
- Salesforce 준비: 인증 메일과 조직 생성에 시간이 걸리니 랩 01 시작 전에 끝내세요. 지침도 사전 진행을 권장합니다.
- 랩 06 지침의 불일치: 곳곳에서 태스크가 5개라고 하지만, 구성 설명에는 Bug Fix 3개 + Build 4개로 7개가 적혀 있습니다. 실제 개수는 tasks/ 폴더에서 확인하세요.
- 랩 08 시나리오의 범위: 시나리오에는 Gmail과 Jira도 나오지만, 실제 작업은 Drive만 다룹니다.
