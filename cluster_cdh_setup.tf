# CDH Cluster Setup

resource "null_resource" "cdh_cluster_setup" {

  depends_on = ["google_compute_instance.cdh_master", "google_compute_instance.cdh_dnode", "null_resource.cdh_adminnode_fuse_java_agent_install", "null_resource.cdh_dnode_fuserepo_java_install",]

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
    "sudo yum install epel-release -y",
    "sudo yum install ansible-2.4.2.0-2.el7 python-pip -y",
    "sudo yum install git gcc -y",
    "sudo pip install cm-api",
    "sudo pip install --upgrade pip",
    "sudo echo -e 'StrictHostKeyChecking no\n' >> ~/.ssh/config; sudo chmod 600 ~/.ssh/config",
#     "git clone https://github.com/alcher/cloudera-centos terraform-hadoop"
##    "git clone https://github.com/poorrabbit/cdh_centos_ansible terraform-hadoop",
##    "git clone https://github.com/alcher/ansible-cloudera-hadoop.git terraform-hadoop",
#    "sleep 10 && cd terraform-hadoop && ansible-playbook -i hosts site.yml"
    ]
  }

}

