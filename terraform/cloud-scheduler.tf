locals {
  # Scheduler configuration files
  scheduler_files = fileset("${path.module}/../deployment/cloudscheduler/", "*.json")
  schedulers = { for file in local.scheduler_files : file => jsondecode(templatefile("${path.module}/../deployment/cloudscheduler/${file}", {
    WORKFLOW_ID    = google_workflows_workflow.workflows_example["get_detail_all_groups.json"].id,
    GCP_PROJECT_ID = var.project_id
    }
    )
  ) }
}

module "cloudschedulers" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-scheduler/?ref=0.7.0"

  for_each      = local.schedulers
  configuration = { "configuration" : each.value }
}
