### prd #######################################################

env                = "prd"
project_id         = "ofr-fgt-shared-data-prd" # project id (!! Not project name!!)
log_sink_folder_id = 681673984390              # OFR
services_configuration = {
  "shared-data-nginx" = {
    service_account_email = "sa-ofr-fgt-cloud-run@ofr-fgt-shared-data-prd.iam.gserviceaccount.com"
    cpus                  = 1
    memory                = 1024
    min_instances         = 0
    max_instances         = 10
    concurrency           = 6
    iam_bindings = [
      {
        role   = "roles/run.invoker"
        member = "serviceAccount:sa-ofr-fgt-workflow@ofr-fgt-shared-data-prd.iam.gserviceaccount.com"
      }
    ]
  }
}
cloud_scheduler_configuration = {
  "cloudscheduler-iam-policies.json" = {
    job_schedule = "0 8-23 * * *"
  },
  "cloudscheduler-groups.json" = {
    job_schedule = "0 8-23 * * *"
  },
  "cloudscheduler-historize-audit-base-data.json" = {
    job_schedule = "25 8 * * *"
  },
  "cloudscheduler-get-departure-and-internal-moves.json" = {
    job_schedule = "25 8 * * *"
  }
}