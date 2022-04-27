{
  "${TOPICPREFIX}-${ENV}": {
    "subscriptions": {
      "${SUBSCRIPTIONPREFIX}-${ENV}": {
        "subscription_push_config": {
          "push_endpoint": "${CLOUDRUN_URI}/query/allowed/",
          "oidc_token": {
            "service_account_email": "${PUBSUB_SA}"
          }
        }
      }
    }
  }
}