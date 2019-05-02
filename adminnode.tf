# Proxy Profile
data "template_file" "admin_metadata_startup_script" {
   template = "${file("scripts/startup_performance.sh")}"
}

# Create cdh admin instances
resource "google_compute_instance" "cdh_master" {
  name         = "${var.unique}-${var.instance_hostname["cdh_master"]}-0${count.index+1}"
  zone         = "${google_compute_subnetwork.subnet_cdh_cluster.region}-b"
  machine_type = "${var.gce_machine_type["cdh_master"]}"

  depends_on = ["google_compute_instance.bastion"]

  //deletion_protection = true
  deletion_protection = false

  lifecycle {
    //prevent_destroy = true
    prevent_destroy = false
  }

  allow_stopping_for_update = true

  tags         = [
    "${var.subnet_network_tags["data_hub_cluster"]}",
    "${var.instance_network_tags["cdh_node"]}",
    "${var.instance_network_tags["natnoip"]}"
  ]

  boot_disk {
    initialize_params {
      image = "${var.gce_image_name["cdh_master"]}"
      size  = "${var.gce_disk_size["cdh_master_boot_disk"]}"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.subnet_cdh_cluster.self_link}"
  }

  metadata {
    ssh-keys = "${var.admin_user}:${file(var.admin_pubkey_file)}"
  }

  metadata_startup_script = "${data.template_file.admin_metadata_startup_script.rendered}"

  service_account {
    email  = "${google_service_account.cdh_cluster.email}"
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  count = "${var.instance_count["cdh_master"]}"
}
