{
  "logsink_name": "ofr-fgt-audit-bqt-${ENV}",
  "logsink_description": "This is a log sink for Cotools (to BigQuery)",
  "logsink_filter": "resource.type=bigquery_resource protoPayload.methodName=jobservice.insert protoPayload.serviceData.jobInsertResponse.resource.jobStatus.state=DONE",
  "logsink_destination_type": "bigquery",
  "logsink_partitioned_table": true,
  "logsink_folder_id": "${FOLDER_ID}",
  "logsink_include_children": true
}