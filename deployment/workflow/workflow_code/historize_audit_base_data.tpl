main:
    steps:
        - historize_data:
            call: http.get
            args:
                url: ${CLOUD_RUN_URI}/teams/history
                auth:
                    type: OIDC
            result: return_historize
        - returnOutput:
            return: $${return_historize}
            