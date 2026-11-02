# 07. Cost/token Estimation, Analysis, and Optimization

## 목표: 멀티 에이전트의 쿼리당 비용을 측정하고, 품질을 유지하면서 절반 수준으로 줄입니다.

##### 핵심 내용
- 질문 하나가 코디네이터 호출, 서브 에이전트 호출, 검색, 추론 토큰으로 퍼져 나가므로 usage ledger로 비용을 분해합니다.
- 절감 수단은 세 가지입니다: 모델 티어링, 컨텍스트 캐싱, 추론·검색 토큰 감축. 변경할 때마다 품질 점수를 측정합니다.

최종 과제 조건


│    항목     │                  조건                   │
|------------|----------------------------------------|
│ 평가 데이터 │ held-out 쿼리 16개                      │
│ 평균 비용   │ $0.0135 이하                            │
│ 평균 품질   │ 0.90 이상                               │
│ Coordinator │ Pro 또는 Flash만 가능 (Flash-Lite 금지) │
│ 임베딩 모델 │ gemini-embedding-001 고정               │
│ 조정 항목   │ MY_MODELS, MY_THINKING, MY_TOPK         │


##### 랩 흐름

1. Workbench에서 JupyterLab을 열고 파일을 확인합니다.
2. 노트북의 설치 셀을 실행하고 커널을 재시작합니다.
3. Part 0에서 Agent Search 리소스를 프로비저닝하고 진행을 체크합니다.
4. 기준 비용을 측정하고 세 가지 수단을 차례로 적용합니다.
5. Part 6의 TODO를 채워 PASS를 받고 final_metrics.json을 업로드합니다. TODO를 채우기 전의 AssertionError는 의도된 동작입니다.

세부 절차는 노트북(code_assistant_cost_optimization.ipynb) 안에 있습니다. 이 노트북은 저장된 HTML에 없어서, 중간 단계는 위의 큰 흐름까지만 확인할 수 있습니다.