locals {
  # Scheduler configuration files
  scheduler_files = fileset("${path.module}/../deployment/cloudscheduler/", "*.json")
  schedulers = { for file in local.scheduler_files : file => jsondecode(templatefile("${path.module}/../deployment/cloudscheduler/${file}", {
    WORKFLOW_GROUP_DETAILS_ID            = google_workflows_workflow.workflows_example["get_detail_all_groups.json"].id,
    WORKFLOW_IAM_POLICIES_ID             = google_workflows_workflow.workflows_example["get_detail_iam_policies.json"].id,
    WORKFLOW_DEPARTURE_INTERNAL_MOVES_ID = google_workflows_workflow.workflows_example["get_departure_and_internal_moves.json"].id,
    WORKFLOW_HISTORIZE_AUDIT_DATA_ID     = google_workflows_workflow.workflows_example["historize_audit_base_data.json"].id,
    GCP_PROJECT_ID                       = var.project_id
    }
    )
  ) }
}

module "cloudschedulers" {
  source = "git::https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-scheduler/?ref=0.7.1"

  for_each = local.schedulers
  configuration = { "configuration" : merge(
    lookup(var.cloud_scheduler_configuration, each.key, {}),
    each.value)
  }
}
