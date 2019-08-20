# Customer settings for provisioning VMs and GCP services (Customer GCP project)
variable "customer_gcp_credentials_file" {}
variable "customer_gcp_project_id"       {}
variable "customer_gcp_region"           { default = "us-west1" }

# GCP services to enable for the project
#
# Use the following Google Cloud SDK command to view enabled project services:
#   gcloud service-management list --enabled
#
# See hashicorp/terraform PR #13730 for info on internal GCP project services that are skipped by terraform.
# PR #13730: https://github.com/hashicorp/terraform/pull/13730
#
# As per PR #13730, do not specify the following GCP managed/Private API services:
#   "containeranalysis.googleapis.com"
#   "dataproc-control.googleapis.com"
#   "source.googleapis.com"
#
variable "customer_gcp_project_services" {
  type    = "list"
  default = [
    # NAME                                    TITLE
    "compute.googleapis.com",              # Google Compute Engine API
    "iam.googleapis.com",                  # Google Identity and Access Management (IAM) API
    "serviceusage.googleapis.com",         # Google Service Usage API
    "storage-component.googleapis.com",    # Google Cloud Storage
    "cloudapis.googleapis.com",            # Google Cloud APIs
    "servicemanagement.googleapis.com",    # Google Service Management API
    "storage-api.googleapis.com",          # Google Cloud Storage JSON API
    "cloudresourcemanager.googleapis.com", # Google Cloud Resource Manager API
    "deploymentmanager.googleapis.com",    # Google Cloud Deployment Manager V2 API
  ]
}

# A unique alphanumeric string to identify this deployment
variable "unique" {}

# GCP reserves 4 IP addresses per subnet (first 2 and last 2 IPs
# Note: This includes the network and broadcast addresses
variable "subnet_cidr_ranges" {
  type    = "map"
  default = {
    "public_services"  = "10.0.4.0/24"   #  252 hosts, start IP .2   (254 hosts minus GCP reserved)
    "cdh_cluster" = "10.0.5.0/24" # 252 hosts, start IP .2 (254 hosts minus GCP reserved)
  }
}

variable "subnet_network_tags" {
  type    = "map"
  default = {
    "public_services"  = "cdh-public"
    "data_hub_cluster" = "cdh-private-cdh-cluster"
  }
}

# Firewall http https tag

variable "rl_firewall_tags" {
  type    = "map"
  default = {
    "rl-http"  = "http-server"
    "rl-https" = "https-server"
  }
}

# Source address or network that may connect
variable "cidr_workstation"              {}

variable "instance_network_tags" {
  type = "map"
  default = {
    "bastion"             = "bastion-servers"
    "cdh_node"            = "cdh-nodes"
    "natnoip"             = "no-ip"
  }
}

variable "instance_hostname" {
  type = "map"
  default = {
    "bastion"              = "bastion"
    "cdh_master"	   = "cdhadmin"
    "cdh_dnode"	   	   = "cdhdata"
  }
}

# GCE instance machine type
variable "gce_machine_type" {
  type = "map"
  default = {
    "bastion"              = "n1-standard-1" #use n1-standard-2
    "cdh_master"           = "n1-highmem-2"  #use n1-standard-2
    "cdh_dnode"            = "n1-standard-2"
  }
}

# Image names for GCE custom images.
variable "gce_image_name" {
  type = "map"
  default = {
    "bastion"              = "centos-cloud/centos-7"
    "cdh_master"           = "centos-cloud/centos-7"
    "cdh_dnode"           = "centos-cloud/centos-7"
  }
}

# Storage class
variable "storage_class" { default = "regional" }

# Secondary disk type
variable "data_disk" {
  type    = "map"
  default = {
    "disktype"          = "pd-standard"
    "disksize"          = "100"
  }
}

# GCE instance disk size in GB
variable "gce_disk_size" {
  type = "map"
  default = {
    "bastion_boot_disk"              = "50"
    "cdh_master_boot_disk"           = "50"
    "cdh_dnode_boot_disk"	     = "50"
  }
}

# IP addresses for VM instances
variable "ip_allocation" {
  type = "map"
  default = {
    # Public Services
    "bastion"      = "10.0.4.2"
  }
}

# Initial deployment user (admin)
variable "admin_user"                    { default = "pythian" }
variable "admin_pubkey_file"             {}
variable "admin_privkey_file"             {}

variable "instance_count" {
  type = "map"
  default = {
    "cdh_master"                = 4
    "cdh_dnode"			= 4
  }
}

# Cloudera Manager Variable
variable "CM_API_PORT"			{ default = "7180" }
variable "CM_API_USER"			{ default = "admin" }
variable "CM_API_PASS"                  { default = "admin" }
variable "CDH_CLUSTER_NAME"		{ default = "Cluster_1" }
