provider "google" {
}

# 1. VPC 네트워크 생성
resource "google_compute_network" "vpc_network" {
  name                    = "web-app-network"
  auto_create_subnetworks = false
}

# 2. 서브넷 생성
resource "google_compute_subnetwork" "web_subnet" {
  name          = "web-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
}

# 3. 방화벽 규칙 생성 (HTTP 및 SSH 허용)
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"] # HTTP, HTTPS
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"] # SSH
  }

  source_ranges = ["0.0.0.0/0"]
}

# 4. 인스턴스 템플릿 생성
resource "google_compute_instance_template" "instance_template" {
  name        = "web-app-template"
  machine_type = "e2-medium"

  tags = ["web"]

  # 부트 디스크 설정
  disk {
    auto_delete = true
    boot        = true
    source_image      = "debian-cloud/debian-11"
  }

  # 네트워크 인터페이스 설정
  network_interface {
    subnetwork = google_compute_subnetwork.web_subnet.id

    access_config {
      # 외부 IP 할당
    }
  }

  # 메타데이터 (웹 애플리케이션 배포 스크립트)
  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    echo "<h1>Hello, World!</h1>" > /var/www/html/index.html
  EOT
}

# 5. Managed Instance Group 생성
resource "google_compute_region_instance_group_manager" "instance_group" {
  name               = "web-instance-group"
  base_instance_name = "web-instance"
  region             = "us-central1"
  target_size        = 2 # 초기 인스턴스 수
  
  # 추가된 version 블록
  version {
    instance_template = google_compute_instance_template.instance_template.self_link
    name              = "v1" # 버전 이름 (선택사항)
  }

  distribution_policy_zones = [
    "us-central1-a",
    "us-central1-b",
    "us-central1-c"
  ]
}

# 6. 오토스케일링 설정
resource "google_compute_region_autoscaler" "autoscaler" {
  name               = "web-app-autoscaler"
  target             = google_compute_region_instance_group_manager.instance_group.id
  region             = "us-central1"

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 2

    cpu_utilization {
      target = 0.6 # CPU 사용률이 60%를 초과하면 스케일 업
    }
  }
}

# 7. 로드 밸런서 백엔드 서비스 생성
resource "google_compute_backend_service" "backend_service" {
  name        = "web-backend-service"
  health_checks = [google_compute_health_check.health_check.self_link]
  backend {
    group = google_compute_region_instance_group_manager.instance_group.instance_group
  }
}

# 8. HTTP 헬스 체크 생성
resource "google_compute_health_check" "health_check" {
  name = "web-health-check"

  http_health_check {
    request_path = "/"
    port         = 80
  }
}

# 9. 로드 밸런서 URL 맵 생성
resource "google_compute_url_map" "url_map" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.backend_service.self_link
}

# 10. 로드 밸런서 HTTP 프록시 생성
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "web-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

# 11. 로드 밸런서 프론트엔드 생성
resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}

