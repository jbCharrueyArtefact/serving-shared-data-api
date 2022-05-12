main:
    steps:
        - get_moves:
            call: http.get
            args:
                url: ${CLOUD_RUN_URI}/teams/get_moves
                auth:
                    type: OIDC
            result: return_get_moves
        - returnOutput:
            return: $${return_get_moves}
            