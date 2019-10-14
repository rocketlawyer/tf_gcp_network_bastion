# Installing FUSE, JAVA and CDH REPO into AdminNode

resource "null_resource" "before_adminnode" {
}

resource "null_resource" "delay_adminnode" {
  provisioner "local-exec" {
    command = "sleep 30"
  }
  triggers = {
    "before" = "${null_resource.before_adminnode.id}"
  }
}

resource "null_resource" "cdh_adminnode_fuse_java_agent_install" {

  depends_on = ["google_compute_instance.cdh_master", "null_resource.delay_adminnode"]

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

  provisioner "file" {
    source      = "scripts/gcsfuse.repo"
    destination = "/tmp/gcsfuse.repo"
  }

  provisioner "remote-exec" {
    inline = [
      "while [ -f /var/run/yum.pid ]; do sleep 3; done",
      "sudo yum clean all -y",
      "sudo cp /tmp/gcsfuse.repo /etc/yum.repos.d/gcsfuse.repo",
      "echo y | sudo rpm --import https://packages.cloud.google.com/yum/doc/yum-key.gpg",
      "echo y | sudo rpm --import https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg",
      "sudo setenforce 0 || /bin/true",
      "sudo systemctl disable firewalld",
      "sudo systemctl stop firewalld",
      "sudo yum check-update -y",
      "sudo yum -y install gcsfuse google-cloud-sdk",
      "sudo yum -y install python",
    ]
  }
  count = "${var.instance_count["cdh_master"]}"
}


