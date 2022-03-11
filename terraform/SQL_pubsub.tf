locals {
  pubsub_topics_for_logging_sink = jsondecode(templatefile("${path.module}/../deployment/pubsub/SQL_pubsub_for_loggingsink.tpl", {
    ENV         = var.env,
    TOPICPREFIX = var.logsink_sql_pubsub_topic_prefix
    }
  ))
}

module "pubsub_for_loggingsink" {
  source                           = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.pubsub/?ref=0.5.0"
  pubsub_topics_subscriptions_list = local.pubsub_topics_for_logging_sink
  message_retention_duration       = "3600s"
  retain_acked_messages            = false
  ack_deadline_seconds             = "30"
}
