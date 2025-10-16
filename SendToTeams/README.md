# Send a message to Microsoft Teams

### Purpose
There is a requirement to push certain GitHub workflow events or notifications into Microsoft Teams (or via Power Automate). 

This routine has been made generic, so that it can be reused if necessary and additional data points can be simply added.

The message payload is structured as JSON (e.g., Adaptive Card), which Teams will render accordingly.

### Input Parameters
* POWER-AUTOMATE-WEBHOOK-URL - Power Automate Webhook URL

### Example
```       

name:  Test Teams Notification
on:
  workflow_dispatch:

jobs:
  TEAMS:
    runs-on: ubuntu-latest
    steps:
    
       - name: Send test message
         uses: DFE-Digital/github-actions/SendToTeams@master
         with:
           POWER-AUTOMATE-WEBHOOK-URL: ${{secrets.POWER_AUTOMATE_URL}}

```


