{
  "logsink_name": "ofr-fgt-audit-pubsub-${ENV}",
  "logsink_description": "This is a log sink for Cotools (to PubSub)",
  "logsink_filter": "resource.type=bigquery_resource protoPayload.methodName=jobservice.insert protoPayload.serviceData.jobInsertResponse.resource.jobStatus.state=DONE protoPayload.serviceData.jobInsertResponse.resource.jobConfiguration.query:*",
  "logsink_destination_type": "pubsub",
  "logsink_folder_id": "${FOLDER_ID}",
  "logsink_include_children": true
}