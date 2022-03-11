locals {
  logsink_file_content_bqt = jsondecode(
    replace(
      file("${path.module}/../deployment/logsink/SQL_logsink_bqt.json"),
      "ENV",
      var.env
    )
  )
  logsink_name_bqt             = local.logsink_file_content_bqt.logsink_name
  logsink_description_bqt      = local.logsink_file_content_bqt.logsink_description
  logsink_filter_bqt           = local.logsink_file_content_bqt.logsink_filter
  logsink_destination_type_bqt = local.logsink_file_content_bqt.logsink_destination_type


  logsink_file_content_pubsub = jsondecode(
    replace(
      file("${path.module}/../deployment/logsink/SQL_logsink_pubsub.json"),
      "ENV",
      var.env
    )
  )
  logsink_name_pubsub             = local.logsink_file_content_pubsub.logsink_name
  logsink_description_pubsub      = local.logsink_file_content_pubsub.logsink_description
  logsink_filter_pubsub           = local.logsink_file_content_pubsub.logsink_filter
  logsink_destination_type_pubsub = local.logsink_file_content_pubsub.logsink_destination_type

  logsink_file_content_gcs = jsondecode(
    replace(
      file("${path.module}/../deployment/logsink/SQL_logsink_gcs.json"),
      "ENV",
      var.env
    )
  )
  logsink_name_gcs             = local.logsink_file_content_gcs.logsink_name
  logsink_description_gcs      = local.logsink_file_content_gcs.logsink_description
  logsink_filter_gcs           = local.logsink_file_content_gcs.logsink_filter
  logsink_destination_type_gcs = local.logsink_file_content_gcs.logsink_destination_type
}

module "logging_sink_bq" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.logging-sink/?ref=1.0.0"

  logsink_name        = local.logsink_name_bqt
  logsink_description = local.logsink_description_bqt
  logsink_filter      = local.logsink_filter_bqt
  destination_type    = local.logsink_destination_type_bqt
  resource_id         = module.big_query_for_logsink.bigquery_dataset_id["${var.logsink_sql_dataset_prefix}_${var.env}"]
}

module "logging_sink_pubsub" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.logging-sink/?ref=1.0.0"

  logsink_name        = local.logsink_name_pubsub
  logsink_description = local.logsink_description_pubsub
  logsink_filter      = local.logsink_filter_pubsub
  destination_type    = local.logsink_destination_type_pubsub
  resource_id         = module.pubsub_for_loggingsink.google_pubsub_topic_id["${var.logsink_sql_pubsub_topic_prefix}_${var.env}"]
}

module "logging_sink_gcs" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.logging-sink/?ref=1.0.0"

  logsink_name        = local.logsink_name_gcs
  logsink_description = local.logsink_description_gcs
  logsink_filter      = local.logsink_filter_gcs
  destination_type    = local.logsink_destination_type_gcs
  resource_id         = module.gcs_buckets_for_logsink.gcs_url["ofr-fgt-sql-logsink-${var.env}"]
}

