# Cloudera Manager Install - admin01

resource "null_resource" "cm_server_install" {

  depends_on = ["google_compute_instance.cdh_master", "null_resource.cdh_adminnode_fuse_java_agent_install",]

  connection {
        agent = false
        user = "${var.admin_user}"
        private_key = "${file(var.admin_privkey_file)}"
        timeout = "2m"
        host = "${google_compute_instance.cdh_master.0.network_interface.0.network_ip}"
        bastion_host = "${google_compute_address.bastion_public_ip.address}"
        bastion_user = "${var.admin_user}"
        bastion_private_key = "${file(var.admin_privkey_file)}"
   }

  provisioner "file" {
    source      = "/tmp/cdh_gcp_account_key.json"
    destination = "~/cdh_gcp_account_key.json"
  }

  provisioner "file" {
    source      = "scripts/cm-server.sh"
    destination = "/tmp/cm-server.sh"
  }

#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/cm-server.sh",
#      "/tmp/cm-server.sh",
#    ]
#  }
}
