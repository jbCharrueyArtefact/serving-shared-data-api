locals {
  logsink_file_content_bqt = jsondecode(templatefile("${path.module}/../deployment/logsink/SQL_logsink_bqt.json.tpl", {
    ENV       = var.env
    FOLDER_ID = var.log_sink_folder_id
    }
  ))
  logsink_name_bqt              = local.logsink_file_content_bqt.logsink_name
  logsink_description_bqt       = local.logsink_file_content_bqt.logsink_description
  logsink_filter_bqt            = local.logsink_file_content_bqt.logsink_filter
  logsink_destination_type_bqt  = local.logsink_file_content_bqt.logsink_destination_type
  logsink_partitioned_table_bqt = lookup(local.logsink_file_content_bqt, "logsink_partitioned_table", false)
  logsink_folder_id_bqt         = local.logsink_file_content_bqt.logsink_folder_id
  logsink_include_children_bqt  = tobool(lookup(local.logsink_file_content_bqt, "logsink_include_children", true))

  logsink_file_content_pubsub = jsondecode(templatefile("${path.module}/../deployment/logsink/SQL_logsink_pubsub.json.tpl", {
    ENV       = var.env
    FOLDER_ID = var.log_sink_folder_id
    }
  ))
  logsink_name_pubsub             = local.logsink_file_content_pubsub.logsink_name
  logsink_description_pubsub      = local.logsink_file_content_pubsub.logsink_description
  logsink_filter_pubsub           = local.logsink_file_content_pubsub.logsink_filter
  logsink_destination_type_pubsub = local.logsink_file_content_pubsub.logsink_destination_type
  logsink_folder_id_pubsub        = local.logsink_file_content_pubsub.logsink_folder_id
  logsink_include_children_pubsub = tobool(lookup(local.logsink_file_content_pubsub, "logsink_include_children", true))

  logsink_file_content_gcs = jsondecode(templatefile("${path.module}/../deployment/logsink/SQL_logsink_gcs.json.tpl", {
    ENV       = var.env
    FOLDER_ID = var.log_sink_folder_id
    }
  ))
  logsink_name_gcs             = local.logsink_file_content_gcs.logsink_name
  logsink_description_gcs      = local.logsink_file_content_gcs.logsink_description
  logsink_filter_gcs           = local.logsink_file_content_gcs.logsink_filter
  logsink_destination_type_gcs = local.logsink_file_content_gcs.logsink_destination_type
  logsink_folder_id_gcs        = local.logsink_file_content_gcs.logsink_folder_id
  logsink_include_children_gcs = tobool(lookup(local.logsink_file_content_gcs, "logsink_include_children", true))
}

module "folder_logging_sink_bq" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.folder-logging-sink/?ref=0.0.0"

  logsink_name           = local.logsink_name_bqt
  logsink_description    = local.logsink_description_bqt
  logsink_filter         = local.logsink_filter_bqt
  include_children       = local.logsink_include_children_bqt
  folder_id              = local.logsink_folder_id_bqt
  destination_type       = local.logsink_destination_type_bqt
  resource_id            = module.big_query_for_logsink.bigquery_dataset_id["${var.logsink_sql_dataset_prefix}_${var.env}"]
  use_partitioned_tables = local.logsink_partitioned_table_bqt
}

module "folder_logging_sink_pubsub" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.folder-logging-sink/?ref=0.0.0"

  logsink_name        = local.logsink_name_pubsub
  logsink_description = local.logsink_description_pubsub
  logsink_filter      = local.logsink_filter_pubsub
  include_children    = local.logsink_include_children_pubsub
  folder_id           = local.logsink_folder_id_pubsub
  destination_type    = local.logsink_destination_type_pubsub
  resource_id         = module.pubsub_for_loggingsink.google_pubsub_topic_id["${var.logsink_sql_pubsub_topic_prefix}-${var.env}"]
}

module "folder_logging_sink_gcs" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.folder-logging-sink/?ref=0.0.0"

  logsink_name        = local.logsink_name_gcs
  logsink_description = local.logsink_description_gcs
  logsink_filter      = local.logsink_filter_gcs
  include_children    = local.logsink_include_children_gcs
  folder_id           = local.logsink_folder_id_gcs
  destination_type    = local.logsink_destination_type_gcs
  resource_id         = module.gcs_buckets_for_logsink.gcs_url["ofr-fgt-sql-logsink-${var.env}"]
}

