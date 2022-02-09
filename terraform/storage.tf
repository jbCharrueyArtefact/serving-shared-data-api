module "gcs_buckets" {
  source      = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-storage/?ref=0.6.0"
  json_path   = "../deployment/gcs_buckets.json"
  environment = var.env
}
