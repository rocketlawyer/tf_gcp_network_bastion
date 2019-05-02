# Allow internal traffic on the cdh_network
resource "google_compute_firewall" "default_allow_internal" {
  name     = "${var.unique}-cdh-default-allow-internal"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 65534

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_tags = [
    "${var.subnet_network_tags["public_services"]}",
    "${var.subnet_network_tags["data_hub_cluster"]}"
  ]

  source_ranges = [
    "${google_compute_subnetwork.subnet_public_services.ip_cidr_range}",
    "${var.subnet_cidr_ranges["cdh_cluster"]}"
  ]

  target_tags = ["${var.instance_network_tags["cdh_node"]}"]
}

# Allow SSH from anywhere
resource "google_compute_firewall" "default_allow_ssh" {
  name     = "${var.unique}-cdh-default-allow-ssh"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 65534

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}

# Allow ICMP from anywhere
resource "google_compute_firewall" "default_allow_icmp" {
  name     = "${var.unique}-cdh-default-allow-icmp"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 65534

  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}

# Allow all egress on the data_hub_cluster
resource "google_compute_firewall" "cdh_cluster_allow_all_egress" {
  name     = "${var.unique}-cdh-cdh-cluster-allow-all-egress"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 200

  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "icmp"
  }

  target_tags = ["${var.instance_network_tags["cdh_node"]}"]
}

# Allow internal ssh to cdh_cluster
resource "google_compute_firewall" "cdh_cluster_allow_ssh_ingress" {
  name     = "${var.unique}-cdh-cdh-cluster-allow-ssh-ingress"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 100

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = [
    "${var.subnet_network_tags["public_services"]}",
    "${var.subnet_network_tags["data_hub_cluster"]}"
  ]

  source_ranges = [
    "${google_compute_subnetwork.subnet_public_services.ip_cidr_range}",
    "${google_compute_subnetwork.subnet_cdh_cluster.ip_cidr_range}"
  ]

  target_tags = ["${var.instance_network_tags["cdh_node"]}"]
}

# Allow internal icmp on the cdh_cluster
resource "google_compute_firewall" "cdh_cluster_allow_icmp_ingress" {
  name     = "${var.unique}-cdh-cdh-cluster-allow-icmp-ingress"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 101

  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  source_tags = [
    "${var.subnet_network_tags["public_services"]}",
    "${var.subnet_network_tags["data_hub_cluster"]}"
  ]

  source_ranges = [
    "${google_compute_subnetwork.subnet_public_services.ip_cidr_range}",
    "${google_compute_subnetwork.subnet_cdh_cluster.ip_cidr_range}"
  ]

  target_tags = ["${var.instance_network_tags["cdh_node"]}"]
}

# Allow internal traffic on the cdh_cluster
resource "google_compute_firewall" "cdh_cluster_allow_internal" {
  name     = "${var.unique}-cdh-cdh-cluster-default-allow-internal"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 102

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_tags = [
    "${var.subnet_network_tags["public_services"]}",
    "${var.subnet_network_tags["data_hub_cluster"]}"
  ]

  source_ranges = [
    "${google_compute_subnetwork.subnet_public_services.ip_cidr_range}",
    "${var.subnet_cidr_ranges["cdh_cluster"]}"
  ]

  target_tags = ["${var.instance_network_tags["cdh_node"]}"]
}

# Deny all traffic on the cdh_cluster
resource "google_compute_firewall" "cdh_cluster_deny_all" {
  name     = "${var.unique}-cdh-cdh-cluster-deny-all"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 1000

  direction = "INGRESS"

  deny {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  deny {
    protocol = "udp"
    ports    = ["1-65535"]
  }

  deny {
    protocol = "icmp"
  }

  target_tags = ["${var.instance_network_tags["cdh_node"]}"]
}

# Allow http and https from anywhere
resource "google_compute_firewall" "default_allow_http_https" {
  name     = "${var.unique}-cdh-default-allow-http-https"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 90

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]

  target_tags = [
     "${var.instance_network_tags["cdh_node"]}",
     "${var.rl_firewall_tags["rl-http"]}",
     "${var.rl_firewall_tags["rl-https"]}"
  ]
}
