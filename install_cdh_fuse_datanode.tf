# Installing FUSE, JAVA and CDH REPO into datanode

resource "null_resource" "before_datanode" {
}

resource "null_resource" "delay_datanode" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
  triggers = {
    "before" = "${null_resource.before_datanode.id}"
  }
}

resource "null_resource" "cdh_dnode_fuserepo_java_install" {

  depends_on = ["google_compute_instance.cdh_dnode", "google_compute_disk.datadisk", "null_resource.delay_datanode", "null_resource.cdh_adminnode_fuse_java_agent_install",]

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
    source      = "scripts/install_packages.sh"
    destination = "/tmp/install_packages.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_packages.sh",
      "/tmp/install_packages.sh",
    ]
  }

  provisioner "file" {
    source      = "scripts/cm-agent.sh"
    destination = "/tmp/cm-agent.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cm-agent.sh",
      "/tmp/cm-agent.sh ${google_compute_instance.cdh_master.0.network_interface.0.network_ip}",
    ]
  }
  count = "${var.instance_count["cdh_dnode"]}"
}
