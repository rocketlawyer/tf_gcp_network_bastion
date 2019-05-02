# Cloudera Manager Install - admin01

resource "null_resource" "cm_pgsql_server_install" {

  depends_on = ["google_compute_instance.cdh_master", "null_resource.cdh_adminnode_fuse_java_agent_install", "null_resource.cm_server_install",]

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
    source      = "../scm_server_db_backup.sql"
    destination = "/tmp/scm_server_db_backup.sql"
  }

  provisioner "file" {
    source      = "scripts/cm_psql_server.sh"
    destination = "/tmp/cm_psql_server.sh"
  }

#  provisioner "remote-exec" {
#    inline = [
#      "chmod +x /tmp/cm_psql_server.sh",
#      "/tmp/cm_psql_server.sh",
#    ]
#  }
}
