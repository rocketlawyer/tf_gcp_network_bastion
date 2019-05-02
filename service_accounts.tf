# Service Accounts
resource "google_service_account" "nat_gateway" {
  depends_on = [
    "google_project_service.project",
  ]

  account_id   = "${var.unique}-nat-gateway"
  display_name = "NAT Gateway"
}

resource "google_service_account" "bastion" {
  depends_on = [
    "google_project_service.project",
  ]

  account_id   = "${var.unique}-bastion"
  display_name = "Bastion Server"
}

# CDH Service account
resource "google_service_account" "cdh_cluster" {
  depends_on = [
    "google_project_service.project",
  ]

  account_id   = "${var.unique}-cdh-cluster"
  display_name = "CDH Cluster"

}

resource "google_service_account_key" "cdh_gcp_account_key" {
  service_account_id = "${google_service_account.cdh_cluster.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "local_file" "cdh_gcp_account_key_json" {
    content     = "${base64decode(google_service_account_key.cdh_gcp_account_key.private_key)}"
    filename = "/tmp/cdh_gcp_account_key.json"
}

resource "google_project_iam_member" "cdh_service_account_iam" {
    role = "roles/storage.objectAdmin"
    member = "serviceAccount:${google_service_account.cdh_cluster.email}"
}
