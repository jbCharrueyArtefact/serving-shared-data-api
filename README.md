# ofr-fgt-shared-data Serving
![client](https://img.shields.io/badge/Client-CDA-purple.svg)
![pipeline](https://img.shields.io/badge/Pipeline-Passed-green.svg)
![infrastructure](https://img.shields.io/badge/IaC-Terraform-green.svg)

* **[Description](#description)**
* **[Pipeline](#pipeline)**
* **[Cloud Run](#cloudrun)**
* **[Cloud Scheduler](#cloudscheduler)**
* **[Logging sink](#loggingsink)**
* **[BigQuery (including for logging sink)](#bigquery)**
* **[Pub/Sub (including for logging sink)](#pubsub)**
* **[GCP Cloud Storage (including for logging sink)](#gcs)**

## Description <a name="description"></a>
This project aims at helping audit and configure crodd-project data access in GCP.

## Pipeline <a name="pipeline"></a>
The pipeline will create the Google resources described in the Terraform files. Here are teh actions executed by the pipeline:

* When a merge request is open, changes are deployed on the dev environment.
* When a merge request is merged (after approval), changes are deployed on the preprod environment.
* When you run a pipeline on the newly released tag, changes are deployed on the prod environment.


## Cloud Run <a name="cloudrun"></a>
See [documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-run/-/blob/0.5.0/README.md).

See [confluence documentation](https://espace.agir.orange.com/display/HDIA/orange.cloud-run).

## Cloud Scheduler <a name="cloudscheduler"></a>
See [documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-scheduler/-/tree/0.6.0).

See [confluence documentation](https://espace.agir.orange.com/display/HDIA/orange.cloud-scheduler).


## Logging sink <a name="loggingsink"></a>
See [developer documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.logging-sink/-/blob/0.1.0/SERVING.md).

See [ops documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.logging-sink/-/blob/0.1.0/README.md).

See [confluence documentation](https://espace.agir.orange.com/display/HDIA/orange.logging-sink).


## BigQuery (including for logging sink) <a name="bigquery"></a>
See [developer documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.bigquery/-/blob/0.42.0/SERVING.md).

See [ops documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.bigquery/-/blob/0.42.0/README.md).

See [confluence documentation](https://espace.agir.orange.com/display/HDIA/orange.bigquery).


## Pub/Sub (including for logging sink) <a name="pubsub"></a>
See [documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.pubsub/-/blob/0.5.0/README.md).

See [confluence documentation](https://espace.agir.orange.com/display/HDIA/orange.pubsub).

## GCP Cloud Storage (including for logging sink) <a name="gcs"></a>
See [documentation](https://gitlab.si.francetelecom.fr/hbx-data-ia/common/terraform-modules/orange.cloud-storage/-/blob/0.11.0/README.md).

See [confluence documentation](https://espace.agir.orange.com/display/HDIA/orange.cloud-storage).
