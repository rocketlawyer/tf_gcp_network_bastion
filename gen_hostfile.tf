# Generate host inventory file for Ansible
resource "null_resource" "admin_host_file" {

  depends_on = ["google_compute_instance.cdh_master"]

  # Create Masters Inventory for admin nodes
  provisioner "local-exec" {
    command =  "echo -e \"[cdh]\"\\nadmin\\ndatanode > /tmp/ahostfile.txt"
    command =  "echo \"[admin]\" >> /tmp/ahostfile.txt"
  }
  provisioner "local-exec" {
    command = "echo ${element(google_compute_instance.cdh_master.*.name, count.index)} ansible_ssh_host=${element(google_compute_instance.cdh_master.*.network_interface.0.network_ip, count.index)} ansible_ssh_port=22 ansible_ssh_user=${var.admin_user} >> /tmp/ahostfile.txt&"
  
  }
  count = "${var.instance_count["cdh_master"]}"
}


resource "null_resource" "dnode_host_file" {

  depends_on = ["google_compute_instance.cdh_dnode"]

  # Create Masters Inventory for data nodes
  provisioner "local-exec" {
    command =  "echo \"[datanode]\" > /tmp/dhostfile.txt"
  }
  provisioner "local-exec" {
    command = "echo ${element(google_compute_instance.cdh_dnode.*.name, count.index)} ansible_ssh_host=${element(google_compute_instance.cdh_dnode.*.network_interface.0.network_ip, count.index)} ansible_ssh_port=22 ansible_ssh_user=${var.admin_user} >> /tmp/dhostfile.txt&"
  
  }
  count = "${var.instance_count["cdh_dnode"]}"
}


resource "null_resource" "combine_hostfile" {
  depends_on = ["null_resource.dnode_host_file", "null_resource.admin_host_file",]
  provisioner "local-exec" {
    command =  "cat /tmp/ahostfile.txt /tmp/dhostfile.txt > /tmp/hostfile.txt && rm /tmp/ahostfile.txt /tmp/dhostfile.txt"
  }
}

