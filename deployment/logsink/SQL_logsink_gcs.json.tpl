{
  "logsink_name": "ofr-fgt-audit-gcs-${ENV}",
  "logsink_description": "This is a log sink for Cotools (for GCS)",
  "logsink_filter": "resource.type = gce_instance",
  "logsink_destination_type": "gcs",
  "logsink_folder_id": "${FOLDER_ID}",
  "logsink_include_children": true
}