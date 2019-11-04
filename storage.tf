# Enable GCP storage
locals { 
  name          = "${var.unique}-storage"
}

resource "google_storage_bucket" "RLCDH" {
  name     	= "${local.name}"
  count         = "${local.name != "" ? 1 : 0}"
  project       = "${var.customer_gcp_project_id}"
  storage_class = "${var.storage_class}"
  location 	= "${var.customer_gcp_storage_region}"
  //force_destroy = true
  
  lifecycle { 
    prevent_destroy = true
    ignore_changes = [ "google_storage_bucket.RLCDH" ]
  }
}