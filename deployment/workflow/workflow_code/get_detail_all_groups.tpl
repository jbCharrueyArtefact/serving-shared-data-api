main:
  steps:
    - get_batch_date:
        call: http.get
        args:
            url: ${CLOUD_RUN_URI}/utils/datetime
            auth:
                type: OIDC
        result: start_date 
    - set_group_batches:
        assign:
            - group_batches: []
            - batch_date: $${start_date.body}
    - getAllGroups:
        call: http.get
        args:
            url: ${CLOUD_RUN_URI}/groups/
            auth:
                type: OIDC
        result: all_groups
    - build_group_batches:
        steps:
            - increment:
                assign:
                    - temp_groups: []
            - collect_group_members:
                for:
                    value: group_id
                    in: $${all_groups.body}
                    steps:
                        - allocate_temp_variables:
                            assign:
                                - temp_groups: $${list.concat(temp_groups, group_id)}
                        - check_if_temp_list_has_10_items:
                            switch:
                                - condition:  $${len(temp_groups) % 150 == 0}
                                  steps:
                                      - add_batch:
                                          assign:
                                            - temp_dict: {
                                                            "groups": "$${temp_groups}", 
                                                            "batch_date": "$${batch_date}"
                                                        }
                                            - group_batches: $${list.concat(group_batches, temp_dict)}
                                            - temp_groups: []
            - add_last_batch:
                switch:
                    - condition:  $${len(temp_groups) > 0}
                      steps:
                        - store_temp_members:
                            assign:
                                - temp_dict: {
                                                "groups": "$${temp_groups}", 
                                                "batch_date": "$${batch_date}"
                                            }
                                - group_batches: $${list.concat(group_batches, temp_dict)}
                                - temp_groups: []
    - parallel-executor:
        call: experimental.executions.map
        args:
            workflow_id: get_group_members_process
            arguments: $${group_batches}
    - returnOutput:
        return: $${group_batches}