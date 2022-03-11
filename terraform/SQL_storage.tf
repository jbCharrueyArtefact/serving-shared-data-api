module "gcs_buckets_for_logsink" {
  source      = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-storage/?ref=0.11.0"
  json_path   = "../deployment/gcs/SQL_gcs_buckets_logsink.json"
  environment = var.env
}
