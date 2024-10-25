1. BigQuery 프로젝트 및 데이터셋 준비
    - Looker에서 사용할 데이터가 있는 BigQuery 프로젝트 및 데이터셋을 설정하고, 쿼리가 정상적으로 실행되는지 확인합니다.
2. Looker에서 연결 설정
    - Looker Admin 메뉴로 이동하여 Connections 설정을 엽니다.
    - 새로운 Connection을 추가하고, 이름을 지정합니다.
    - Dialect로 Google BigQuery Standard SQL을 선택합니다.
3. BigQuery에 Looker 서비스 계정 추가
    - Looker에서 BigQuery에 연결하기 위해서는 Looker의 서비스 계정이 필요합니다.
    - Looker에서 Service Account JSON 파일을 생성하고, 이 파일을 BigQuery 프로젝트에 연결된 서비스 계정으로 추가하여 Looker가 - 해당 데이터에 접근할 수 있도록 합니다.
    - BigQuery 콘솔에서 서비스 계정에 대한 IAM 권한을 부여하여 Looker가 데이터를 조회할 수 있도록 설정합니다.
4. 서비스 계정 JSON 키 업로드
    - Looker의 Connection 설정에서 Service Account JSON Key 필드에 서비스 계정의 JSON 파일을 업로드합니다.
    - Project ID는 BigQuery 프로젝트의 ID로, Looker가 데이터를 쿼리할 프로젝트를 지정합니다.
5. 쿼리 및 모델 생성
    - 연결이 완료되면 Looker에서 BigQuery의 테이블과 데이터를 기반으로 View와 Model을 생성합니다.
    - LookML을 통해 데이터를 모델링하고, 필요한 대시보드 및 쿼리를 작성합니다.
6. 테스트 및 시각화 생성
    - 연결 설정이 끝나면 Looker의 탐색 기능을 사용하여 데이터를 조회하고 쿼리를 테스트합니다.
    - 테스트가 완료되면, 대시보드 및 시각화를 구성하여 데이터를 활용합니다.