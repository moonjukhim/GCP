
1. 772658514059-compute@developer.gserviceaccount.com 서비스 계정의 키 생성

2. 사용자의 cloud shell 홈 디렉토리에 업로드(account.json으로 생성)

3. provider.tf 파일에 oauth 인증 정보를 제공

```json
terraform {
  required_version = ">= 0.12"
}

provider "google" {
  credentials = "${file("/home/c3ddaf58cb56/account.json")}"
  project = var.project_id
  region  = var.gcp_region_1
  zone    = var.gcp_zone_1
}
```