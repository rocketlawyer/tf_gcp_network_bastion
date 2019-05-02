# Data Disk - attach to data node servers
resource "google_compute_disk" "datadisk" {
  count         = "${var.instance_count["cdh_dnode"]}"
  name         = "${var.unique}-${var.instance_hostname["cdh_dnode"]}-0${count.index+1}-datadisk"
  type         = "${var.data_disk["disktype"]}"
  zone          = "${google_compute_subnetwork.subnet_public_services.region}-b"
  size         = "${var.data_disk["disksize"]}"

  lifecycle {
    //prevent_destroy = true
    prevent_destroy = false
  }

}

# Mounting the data disk for datanodes
resource "null_resource" "cdh_dnode_mount" {

#  triggers {
#    cdh_dnode_mount_ids = "${join(",", google_compute_instance.cdh_dnode.*.id)}"
#  }

  depends_on = ["google_compute_instance.cdh_dnode", "google_compute_disk.datadisk"]

  connection {
        agent = false
        user = "${var.admin_user}"
        private_key = "${file(var.admin_privkey_file)}"
        timeout = "2m"
        host = "${element(google_compute_instance.cdh_dnode.*.network_interface.0.network_ip, count.index)}"
        bastion_host = "${google_compute_address.bastion_public_ip.address}"
        bastion_user = "${var.admin_user}"
        bastion_private_key = "${file(var.admin_privkey_file)}"
   }

  provisioner "file" {
    source      = "scripts/data_disks.sh"
    destination = "/tmp/data_disks.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/data_disks.sh",
      "sudo /tmp/data_disks.sh",
    ]
  }
  count = "${var.instance_count["cdh_dnode"]}"
}

