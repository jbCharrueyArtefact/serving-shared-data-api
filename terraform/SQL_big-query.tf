locals {
  big_query_datasets_for_logsink = jsondecode(templatefile("${path.module}/../deployment/big-query/SQL_bq-for-logsink.tpl", {
    ENV           = var.env,
    DATASETPREFIX = var.logsink_sql_dataset_prefix
    }
  ))
}

module "big_query_for_logsink" {
  source   = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.bigquery/?ref=0.40.3"
  project  = var.project_id
  datasets = local.big_query_datasets_for_logsink
}
