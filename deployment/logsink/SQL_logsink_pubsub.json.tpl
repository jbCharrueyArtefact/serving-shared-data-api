{
  "logsink_name": "ofr-fgt-audit-pubsub-${ENV}",
  "logsink_description": "This is a log sink for Cotools (to PubSub)",
  "logsink_filter": "resource.type = gce_instance",
  "logsink_destination_type": "pubsub",
  "logsink_folder_id": "${FOLDER_ID}",
  "logsink_include_children": true
}