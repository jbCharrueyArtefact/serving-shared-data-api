main:
  steps:
    - get_batch_date:
        call: http.get
        args:
            url: ${CLOUD_RUN_URI}/policies/publish
            auth:
                type: OIDC
        result: start_date 
    - returnOutput:
        return: $${start_date}