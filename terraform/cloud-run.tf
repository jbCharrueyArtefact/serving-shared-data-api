locals {
  config_files = fileset("${path.module}/../deployment/cloudrun/", "*.json")
  config_files_content = [
    for file in local.config_files : jsondecode(templatefile("${path.module}/../deployment/cloudrun/${file}", {
      ENV = var.env
    }))
  ]
  services = flatten([
    for file_content in local.config_files_content : [
      {
        # Fields accessed directly are mandatory, lookups are done on optional fields with fallback to default values
        project               = var.project_id
        name                  = file_content.name
        image                 = file_content.image
        location              = file_content.location
        allow_public_access   = file_content.allow_public_access
        cloudsql_connections  = lookup(merge(var.services_configuration[file_content.name], file_content), "cloudsql_connections", [])
        concurrency           = lookup(merge(var.services_configuration[file_content.name], file_content), "concurrency", null)
        env                   = lookup(merge(var.services_configuration[file_content.name], file_content), "env", {})
        env_secret            = lookup(merge(var.services_configuration[file_content.name], file_content), "env_secret", {})
        ingress               = file_content.ingress
        labels                = lookup(merge(var.services_configuration[file_content.name], file_content), "labels", {})
        map_domains           = lookup(merge(var.services_configuration[file_content.name], file_content), "map_domains", [])
        max_instances         = lookup(merge(var.services_configuration[file_content.name], file_content), "max_instances", 1)
        min_instances         = lookup(merge(var.services_configuration[file_content.name], file_content), "min_instances", 1)
        cpus                  = lookup(merge(var.services_configuration[file_content.name], file_content), "cpus", 1)
        memory                = lookup(merge(var.services_configuration[file_content.name], file_content), "memory", 1)
        port                  = file_content.port
        service_account_email = merge(var.services_configuration[file_content.name], file_content).service_account_email
        timeout               = lookup(merge(var.services_configuration[file_content.name], file_content), "timeout", 1200)
        vpc_access_egress     = lookup(file_content, "vpc_access_egress", null)
        vpc_connector_name    = lookup(merge(var.services_configuration[file_content.name], file_content), "vpc_connector_name", null),
        iam_bindings          = lookup(merge(var.services_configuration[file_content.name], file_content), "iam_bindings", [])
      }
    ]
  ])
}

module "cloud_run" {
  for_each = {
    for service in local.services : service.name => service
  }
  source                = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-run.git/?ref=0.5.0"
  project               = each.value.project
  name                  = each.value.name
  image                 = each.value.image
  location              = each.value.location
  allow_public_access   = each.value.allow_public_access
  cloudsql_connections  = each.value.cloudsql_connections
  concurrency           = each.value.concurrency
  env                   = each.value.env
  env_secret            = each.value.env_secret
  ingress               = each.value.ingress
  labels                = each.value.labels
  map_domains           = each.value.map_domains
  max_instances         = each.value.max_instances
  min_instances         = each.value.min_instances
  cpus                  = each.value.cpus
  memory                = each.value.memory
  port                  = each.value.port
  service_account_email = each.value.service_account_email
  timeout               = each.value.timeout
  vpc_access_egress     = each.value.vpc_access_egress
  vpc_connector_name    = each.value.vpc_connector_name
  iam_bindings          = each.value.iam_bindings
}
