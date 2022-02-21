# Local variables
locals {
  files = fileset("../deployment/app-engine/", "*.json")
  json_data = { for file in local.files :
    file => jsondecode(file("../deployment/app-engine/${file}"))
  }
}

# App engine application
resource "google_app_engine_application" "app" {
  project     = var.project_id
  location_id = "europe-west"
}

# Firewall rules
resource "google_app_engine_firewall_rule" "rule" {
  for_each = {
    for subnet in var.remote_subnet_list : "${subnet}" => {
      subnet   = subnet
      priority = 1001 + index(var.remote_subnet_list, subnet)
    }
  }
  project      = google_app_engine_application.app.project
  description  = "Allow Orange internal IPs (${each.value.subnet} / ${each.value.priority})"
  priority     = each.value.priority
  action       = "ALLOW"
  source_range = each.value.subnet
}

resource "google_app_engine_firewall_rule" "rule_default" {
  project      = google_app_engine_application.app.project
  description  = "Override default priority - deny all by default"
  priority     = 2147483646
  action       = "DENY"
  source_range = "*"
}

# App engine service 
resource "google_app_engine_standard_app_version" "appengine" {
  for_each   = local.json_data
  version_id = each.value.version_id
  service    = each.value.service
  runtime    = each.value.runtime

  entrypoint {
    shell = each.value.entrypoint
  }

  deployment {
    zip {
      source_url = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object[each.key].name}"
    }
  }

  env_variables = {
    port = each.value.port
  }

  automatic_scaling {
    max_concurrent_requests = 10
    min_idle_instances      = 1
    max_idle_instances      = 3
    min_pending_latency     = "1s"
    max_pending_latency     = "5s"
    standard_scheduler_settings {
      target_cpu_utilization        = 0.5
      target_throughput_utilization = 0.75
      min_instances                 = 2
      max_instances                 = 10
    }
  }
}

resource "null_resource" "curl_zip" {
  for_each = local.json_data
  provisioner "local-exec" {
    command     = "curl --create-dirs -sLo ./${each.value.service}/${each.value.filename} '${each.value.source}/${each.value.filename}'"
    interpreter = ["/bin/bash", "-c"]
  }

  triggers = {
    always_run = timestamp()
  }
}

# Bucket to store zip objects
resource "google_storage_bucket" "bucket" {
  name                        = "${var.project_id}-appengine-bucket"
  uniform_bucket_level_access = true
  location                    = "EU"
}

# Zip objects 
resource "google_storage_bucket_object" "object" {
  for_each   = local.json_data
  name       = "${each.value.service}.zip"
  bucket     = google_storage_bucket.bucket.name
  source     = "./${each.value.service}/${each.value.filename}"
  depends_on = [null_resource.curl_zip]
}
