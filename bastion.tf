data "google_compute_default_service_account" "default" {}

# Provision the static IPs for bastion instance
resource "google_compute_address" "bastion_public_ip" {
  name   = "${var.unique}-cdh-bastion-public-ip"
  region = "${google_compute_subnetwork.subnet_public_services.region}"
}

# Allow SSH from the Internet (to bastion instance public IP address)
resource "google_compute_firewall" "bastion_allow_public_ssh_ingress" {
  name     = "${var.unique}-cdh-bastion-allow-public-ssh-ingress"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 100

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.cidr_workstation}"]
  target_tags   = ["${var.instance_network_tags["bastion"]}"]
}

resource "google_compute_firewall" "bastion_allow_internal_proxy_ingress" {
  name     = "${var.unique}-cdh-bastion-allow-internal-proxy-ingress"
  network  = "${google_compute_network.cdh_network.name}"
  priority = 100

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "3128"]
  }

  source_ranges = [
     "${var.subnet_cidr_ranges["cdh_cluster"]}",
     "${var.subnet_cidr_ranges["public_services"]}"
  ]
  target_tags   = ["${var.instance_network_tags["bastion"]}"]
}


####
data "template_file" "metadata_startup_script" {
   template = "${file("scripts/bastion_startup.sh")}"
}

# Create bastion instance
resource "google_compute_instance" "bastion" {
  name         = "${var.unique}-${var.instance_hostname["bastion"]}"
  zone         = "${google_compute_subnetwork.subnet_public_services.region}-b"
  machine_type = "${var.gce_machine_type["bastion"]}"

  //deletion_protection = true
  deletion_protection = false
 
  can_ip_forward = true

  lifecycle {
    //prevent_destroy = true
    prevent_destroy = false
  }

  allow_stopping_for_update = true

  tags = [
    "${var.subnet_network_tags["public_services"]}",
    "${var.instance_network_tags["bastion"]}",
    "${var.rl_firewall_tags["rl-http"]}",
    "${var.rl_firewall_tags["rl-https"]}",
    "nat",
  ]

  boot_disk {
    initialize_params {
      image = "${var.gce_image_name["bastion"]}"
      size  = "${var.gce_disk_size["bastion_boot_disk"]}"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.subnet_public_services.self_link}"
    network_ip    = "${var.ip_allocation["bastion"]}"

    access_config {
      nat_ip = "${google_compute_address.bastion_public_ip.address}"
    }
  }

  metadata {
    ssh-keys = "${var.admin_user}:${file(var.admin_pubkey_file)}"
  }

  metadata_startup_script = "${data.template_file.metadata_startup_script.rendered}"

  service_account {
    email  = "${google_service_account.bastion.email}"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}
