locals {
  big_query_datasets = jsondecode(replace(file("${path.module}/../deployment/big-query/big-query-datasets.json"), "$ENV", var.env))
}

module "big_query" {
  source   = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.bigquery/?ref=0.38.0"
  project  = var.project_id
  datasets = local.big_query_datasets
}
