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