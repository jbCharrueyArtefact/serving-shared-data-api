locals {
  workflow_files = fileset("${path.module}/../deployment/workflow/", "*.json")
  workflows = { for file in local.workflow_files : file => jsondecode(templatefile("${path.module}/../deployment/workflow/${file}", {
    GCP_PROJECT_ID = var.project_id,
    CLOUD_RUN_URI  = module.cloud_run["shared-data-nginx"].url
    }
    )
  ) }
}

resource "google_workflows_workflow" "workflows_example" {
  for_each        = local.workflows
  name            = each.value.name
  region          = var.region
  description     = each.value.description
  service_account = each.value.service_account
  source_contents = templatefile(each.value.source_content, jsondecode(each.value.variables))
}