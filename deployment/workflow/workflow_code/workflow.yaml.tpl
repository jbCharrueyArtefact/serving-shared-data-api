# This is a sample workflow, feel free to replace it with your source code
#
# This workflow does the following:
# - reads current time and date information from an external API and stores
#   the response in CurrentDateTime variable
# - retrieves a list of Wikipedia articles related to the day of the week
#   from CurrentDateTime
# - returns the list of articles as an output of the workflow
# FYI, In terraform you need to escape the $$ or it will cause errors.

- getCurrentTime:
    call: http.get
    args:
        url: https://us-central1-workflowsample.cloudfunctions.net/datetime
    result: CurrentDateTime
- readWikipedia:
    call: http.get
    args:
        url: https://en.wikipedia.org/w/api.php
        query:
            action: opensearch
            search: $${CurrentDateTime.body.dayOfTheWeek}
    result: WikiResult
- triggerCloudRunUri:
    call: http.get
    args:
      url: ${CLOUD_RUN_URI}
      auth:
        type: OIDC
- returnOutput:
    return: $${WikiResult.body[1]}