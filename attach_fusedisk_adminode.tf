# mounting fuse / storage disk to admin nodes

resource "null_resource" "cdh_admin_node_mount" {

#  triggers {
#    cdh_dnode_mount_ids = "${join(",", google_compute_instance.cdh_dnode.*.id)}"
#  }

  depends_on = ["google_compute_instance.cdh_master", "null_resource.cdh_adminnode_fuse_java_agent_install"]

  connection {
        agent = false
        user = "${var.admin_user}"
        private_key = "${file(var.admin_privkey_file)}"
        timeout = "2m"
        host = "${element(google_compute_instance.cdh_master.*.network_interface.0.network_ip, count.index)}"
        bastion_host = "${google_compute_address.bastion_public_ip.address}"
        bastion_user = "${var.admin_user}"
        bastion_private_key = "${file(var.admin_privkey_file)}"
   }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /mnt/fuse_stor",
      "sudo gcsfuse rlcdh101-storage /mnt/fuse_stor",
    ]
  }
  count = "${var.instance_count["cdh_master"]}"
}
