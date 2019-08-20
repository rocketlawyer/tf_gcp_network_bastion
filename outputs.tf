#################################################
# Outputs for public services
#################################################

output "bastion_ip" {
  value = "${google_compute_address.bastion_public_ip.address}"
}

#output "self_link" {
#  value       = ["${google_storage_bucket.RLCDH.*.self_link}"]
#  description = "The URI of the created resource."
#}

#output "url" {
#  value       = ["${google_storage_bucket.RLCDH.*.url}"]
#  description = "The base URL of the bucket, in the format gs://<bucket-name>."
#}

#output "name" {
#  value       = ["${google_storage_bucket.RLCDH.*.name}"]
#  description = "The name of bucket."
#}

output "CM_URL" {
  value       = "http://${google_compute_instance.cdh_master.0.network_interface.0.network_ip}:${var.CM_API_PORT}"
  description = "Cloudera Manager URL"
}
