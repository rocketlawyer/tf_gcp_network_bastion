provider "google" {
  credentials = "${file(var.customer_gcp_credentials_file)}"
  project     = "${var.customer_gcp_project_id}"
  region      = "${var.customer_gcp_region}"
}
