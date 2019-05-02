# Enable project services for terraform and deployment
resource "google_project_service" "project" {
  project            = "${var.customer_gcp_project_id}"
  service            = "${element(var.customer_gcp_project_services, count.index)}"
  disable_on_destroy = false

  count = "${length(var.customer_gcp_project_services)}"
}
