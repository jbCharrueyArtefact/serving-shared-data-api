locals {
  pubsub_topics_for_logging_sink = jsondecode(templatefile("${path.module}/../deployment/pubsub/SQL_pubsub_for_loggingsink.tpl", {
    ENV                = var.env
    TOPICPREFIX        = var.logsink_sql_pubsub_topic_prefix
    SUBSCRIPTIONPREFIX = var.logsink_sql_pubsub_subs_prefix
    CLOUDRUN_URI       = module.cloud_run["shared-data-nginx"].url
    PUBSUB_SA          = "sa-ofr-fgt-pubusb-subscription@${var.project_id}.iam.gserviceaccount.com"
    }
  ))
}

module "pubsub_for_loggingsink" {
  source                      = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.pubsub/?ref=1.1.1"
  pubsub_topics_subscriptions = local.pubsub_topics_for_logging_sink
  message_retention_duration  = "3600s"
  retain_acked_messages       = false
  ack_deadline_seconds        = "30"
}
