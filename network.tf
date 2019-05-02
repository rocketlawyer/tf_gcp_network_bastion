resource "google_compute_network" "cdh_network" {
  name                    = "${var.unique}-cdh-network"
  project                 = "${var.customer_gcp_project_id}"
  auto_create_subnetworks = "false"
  description             = "Cloudera Datahub Network"
}

resource "google_compute_subnetwork" "subnet_public_services" {
  name          = "${var.unique}-cdh-subnet-public-services"
  ip_cidr_range = "${lookup(var.subnet_cidr_ranges, "public_services")}"
  network       = "${google_compute_network.cdh_network.self_link}"
  region        = "${var.customer_gcp_region}"
  description   = "CDH Subnet (Public) - Public Services"

  # VMs in this subnet can access Google services without assigned external IP addresses.
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet_cdh_cluster" {
  name          = "${var.unique}-cdh-subnet-cdh-cluster"
  ip_cidr_range = "${lookup(var.subnet_cidr_ranges, "cdh_cluster")}"
  network       = "${google_compute_network.cdh_network.self_link}"
  region        = "${var.customer_gcp_region}"
  description   = "CDH Subnet (Private) - CDH Cluster"

  # VMs in this subnet can access Google services without assigned external IP addresses.
  private_ip_google_access = true
}

resource "google_compute_route" "no_ip_internet_route" {
  name = "no-ip-internet-route"
  dest_range = "0.0.0.0/0"
  network = "${google_compute_network.cdh_network.self_link}"
  next_hop_instance = "${google_compute_instance.bastion.name}"
  next_hop_instance_zone = "${google_compute_instance.bastion.zone}"
  priority = 800
  tags = ["${var.instance_network_tags["natnoip"]}"]
}
