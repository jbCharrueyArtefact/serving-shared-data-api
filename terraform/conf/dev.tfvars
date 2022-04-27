### dev #######################################################

env                = "dev"
project_id         = "ofr-fgt-shared-data-dev" # project id (!! Not project name!!)
log_sink_folder_id = 713604594771              # OFR / Sandbox
services_configuration = {
  "shared-data-nginx" = {
    service_account_email = "sa-ofr-fgt-cloud-run@ofr-fgt-shared-data-dev.iam.gserviceaccount.com"
    cpus                  = 1
    memory                = 1024
    min_instances         = 0
    max_instances         = 10
    concurrency           = 6
    iam_bindings = [
      {
        role   = "roles/run.invoker"
        member = "serviceAccount:sa-ofr-fgt-workflow@ofr-fgt-shared-data-dev.iam.gserviceaccount.com"
      },
      {
        role   = "roles/run.invoker"
        member = "serviceAccount:sa-ofr-fgt-pubusb-subscription@ofr-fgt-shared-data-dev.iam.gserviceaccount.com"
      },
    ]
  }
}