# ofr-fgt-shared-data Serving

# Table of contents
1. [Description](#description)
2. [Pipeline Workflow](#pipelineWf)
3. [Pipeline Configuration Variables](#pipelineVar)
4. [Serving BigQuery](#servingBq)
5. [Serving Cloud Run](#servingCloudRun)
6. [Serving Cloud Scheduler](#servingScheduler)
7. [Serving Workflows](#servingWorkflow)


## Description <a name="description"></a>
This project is part of the CoTools initiative.

## Pipeline Workflow <a name="pipelineWf"></a>

* When a merge request is open, changes are deployed on the dev environment.
* When a merge request is merged (after approval), changes are deployed on the preprod environment.
* When you run a pipeline on the newly released tag, changes are deployed on the prod environment.

## Pipeline Configuration Variables <a name="pipelineVar"></a>

| Name | Description | Value | Required |
| -------------------------- | ----------------------------------------- | -------- | ------- |
| TYPE   | Mandatory technical variable - should not be modified | N/A | Mandatory |
| VAULT_ENGINE   | Mandatory technical variable - should not be modified | N/A | Mandatory |
| AUTO_APPLY   | When set to true, the terraform apply jobs will be automatic. This mean you are losing the opportunity to manually check your terraform plan in order to be sure of the change you will apply. | "true" or "false" | Optional |
| SKIP_PREPROD   | When set to true, everything related to preprod deployment will be skipped | "true" or "false" | Optional |
| SKIP_PROD   | When set to true, everything related to prod deployment will be skipped | "true" or "false" | Optional |
| SKIP_ITOP   | When set to true, the job that declare a production change will be skipped - must only be used when the use-cases are not in production | "true" or "false" | Optional |

Random exemple of possible configuration:
```
variables:
  TYPE: "serving" # either provisioning or serving
  VAULT_ENGINE: "ofr-0np-rawstor-cltgp" # format is <country>-<basicat>-<workload> ex : "ofr-pfd-profiling-sab"
  AUTO_APPLY: "true" 
  SKIP_ITOP: "false"  
```

## Serving BigQuery <a name="servingBq"></a>

BQ Dataset declaration must be done in `./deployment/big-query/big-query-datasets.json`.

BQ Tables declaration must be done in `./deployment/big-query/schema/example-table.json` (does not exist at project initialisation)

Latest documentation:

On Confluence (versions list): https://espace.agir.orange.com/display/HDIA/orange.bigquery

On Gitlab (latest version): https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.bigquery#usage-serving-repo


## Serving Cloud Run <a name="servingCloudRun"></a>
Cloud Run configuration must be done in `./deployment/cloudrun/cloud-run.json`. 

Latest documentation:

On Confluence (versions list): https://espace.agir.orange.com/display/HDIA/orange.cloud-run

On Gitlab (latest version): https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-run/

## Serving Cloud Scheduler <a name="servingScheduler"></a>
Cloud Scheduler configuration must be done in `./deployment/cloudscheduler/cloudscheduler-test.json`. 

Latest documentation:

On Confluence (versions list): https://espace.agir.orange.com/display/HDIA/orange.cloud-scheduler

On Gitlab (latest version): https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-scheduler/

## Serving Workflows <a name="servingWorkflow"></a>
Cloud Workflow configuration must be done in `./deployment/workflow/workflow.json`. This encompasses all workflow configuration to be used but code. The code itself is defined in `./deployment/workflow/workflow_code/workflow.yaml.tpl`.

| Name | Description | Value | Required |
| -------------------------- | ----------------------------------------- | -------- | ------- |
| name   | Name of the workflow to be deployed. | N/A | Mandatory |
| description   | Workflow description. | N/A | Mandatory |
| service_account  | Service Account used to run the workflow code. | N/A | Mandatory |
| source_content   | Path of the file containing the Workflow code. This file is parsed as a terraform [template file](https://www.terraform.io/language/functions/templatefile), meaning that you can use dynamic variables inside this code, as `${my_variable}`. The value assigned to this field is calculated thanks to the `variable` field (see below).  | N/A | Mandatory |
| variables   | Map of variables (as keys) and values to dynamically set content in `source_content` file. The value part of the map is populated thanks to the `locals` defined in `workflow.tf`. | N/A | Mandatory |
