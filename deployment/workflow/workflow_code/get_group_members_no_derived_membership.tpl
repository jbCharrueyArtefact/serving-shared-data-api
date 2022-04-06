main:
    params: [args]
    steps:
    - getGroupMembers:
        call: http.post
        args:
            url: ${CLOUD_RUN_URI}/groups/members
            body:
                groups: $${args.groups}
                batch_date: $${args.batch_date}
                include_derived_membership: False
            auth:
                type: OIDC
        result: result
    - returnOutput:
        return: $${result}

