- define:
    assign: 
        - all_members: []
        - i: 0
- getGroups:
    call: http.get
    args:
        url: https://europe-west3-workflowsample.cloudfunctions.net/groups/
    result: all_groups
- checkCondition:
    switch:
        - condition: ${i =< len(all_groups)/2}
          next: getMembers
    next: returnResult
- getMembers:
    steps:
        - increment:
            assign:
                - start-index: ${i}
                - i: ${i+1}
        - get_members:
            call: http.get
            args:
                url: https://europe-west3-workflowsample.cloudfunctions.net/groups/members/
                args: 
                    groups: all-groups[${start_index}, ${start_index+2}]
            result: members
        - store_results:
            assign:
                - all_members: ${all_members} + ${members}
            next: checkCondition
- returnResult:
    return: ${all_members}