# VPC 네트워크 1 생성 (mynet)
resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = false
}

# VPC 네트워크 2 생성 (privatenet)
resource "google_compute_network" "privatenet" {
  name                    = "privatenet"
  auto_create_subnetworks = false
}

# 서브넷 1 생성 (mynetwork-subnet-us)
resource "google_compute_subnetwork" "mynetwork_subnet" {
  name          = "mynetwork-subnet-us"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.mynetwork.id
}

# 서브넷 2 생성 (privatenet-subnet-us)
resource "google_compute_subnetwork" "privatenet_subnet" {
  name          = "privatenet-subnet-us"
  ip_cidr_range = "172.16.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.privatenet.id
}

# 방화벽 규칙 생성 (SSH 허용 for mynetwork)
resource "google_compute_firewall" "mynetwork_allow_ssh" {
  name    = "mynetwork-allow-ssh"
  network = google_compute_network.mynetwork.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # 모든 IP 대역 허용 (보안에 유의!)
}

# 방화벽 규칙 생성 (SSH 허용 for privatenet)
resource "google_compute_firewall" "privatenet_allow_ssh" {
  name    = "privatenet-allow-ssh"
  network = google_compute_network.privatenet.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"] # 모든 IP 대역 허용 (보안에 유의!)

  # target_tags = ["ssh-allow-rule"]
}


# Create the mynet-us-vm instance
module "mynetwork-us-vm" {
  source           = "./instance"
  instance_name    = "mynetwork-us-vm"
  instance_zone    = "us-central1-a"
  instance_network = google_compute_network.mynetwork.self_link
  instance_subnetwork = google_compute_subnetwork.mynetwork_subnet.self_link
}
# Create the mynet-eu-vm" instance
module "mynet-eu-vm" {
  source           = "./instance"
  instance_name    = "mynet-eu-vm"
  instance_zone    = "us-central1-a"
  instance_network = google_compute_network.privatenet.self_link
  instance_subnetwork = google_compute_subnetwork.privatenet_subnet.self_link
}

