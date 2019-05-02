# CDH Cluster Setup

resource "null_resource" "cdh_cluster_setup" {

  depends_on = ["google_compute_instance.cdh_master", "google_compute_instance.cdh_dnode", "null_resource.cdh_adminnode_fuse_java_agent_install", "null_resource.cm_server_install",]

  connection {
        agent = true
        timeout = "2m"
        host = "${google_compute_address.bastion_public_ip.address}"
        user = "${var.admin_user}"
        private_key = "${file(var.admin_privkey_file)}"
   }

  provisioner "file" {
    source      = "/tmp/hostfile.txt"
    destination = "/tmp/hostfile.txt"
  }

  provisioner "remote-exec" {
    inline = [
    "sudo apt-add-repository ppa:ansible/ansible -y && sudo apt update",
    "sudo apt install git gcc ansible python-pip -y",
    "sudo pip install cm-api",
    "sudo pip install --upgrade pip",
    "sudo echo -e 'StrictHostKeyChecking no\n' >> ~/.ssh/config; sudo chmod 600 ~/.ssh/config",
    "git clone https://github.com/alcher/ansible-cloudera-hadoop.git terraform-hadoop",
    "sleep 10 && cd terraform-hadoop && ansible-playbook -i hosts site.yml"
    ]
  }

}

