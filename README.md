# ofr-fgt-shared-data Serving
![client](https://img.shields.io/badge/Client-CDA-purple.svg)
![pipeline](https://img.shields.io/badge/Pipeline-Passed-green.svg)
![infrastructure](https://img.shields.io/badge/IaC-Terraform-green.svg)

* **[Description](#description)**
* **[Pipeline](#pipeline)**

## Description
Long description.

## Buckets How-to
Bucket declaration must be done in `./deployment/gcs_buckets.json`. Here are examples of how to declare buckets.

```json
[
  {
    "name": "ofr-<basicat>-data-bucket_name1",
    "location": "EU"
  },
  {
    "name": "ofr-<basicat>-data-bucket_name2",
    "location": "EU",
    "lifecycle_rules": [],
    "notifications": []
  },
  {
    "name": "ofr-<basicat>-data-bucket_name3",
    "location": "EU",
    "lifecycle_rules": [],
    "notifications": [
      {
        "topic": "cda_gcs_notifications",
        "payload_format": "JSON_API_V1",
        "event_types": ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"],
        "custom_attributes": {
          "project": "example",
          "team": "acdi"
        }
      }
    ]
  }
]
```

## Pipeline 
The pipeline will create the Google resources described in the Terraform files. Here are teh actions executed by the pipeline:

* When a merge request is open, changes are deployed on the dev environment.
* When a merge request is merged (after approval), changes are deployed on the preprod environment.
* When you run a pipeline on the newly released tag, changes are deployed on the prod environment.
