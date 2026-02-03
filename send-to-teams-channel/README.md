# Send to teams channel

Send a message to a teams channel.
Requires a Power Automate webhook url for the channel you are sending the message too.
- contact the devops team to create a webhook url for you, or for instructions on how to create your own
A minimal message (minimal: true), only includes title, service and message
A full message (minimal: false), has the above plus workflow run, environment, user, branch and reference.
A success message (status: success) displays the title in green.
A failure message (status: failure) displays the title in red.

## Inputs
- `teams-webhook-url`: A valid webhook url for the target teams channel
- `title`: Title of teams message (default: "Workflow notification")
- `service`: Name of the service (default: "Unset")
- `messsage`: Message to display (default: "Unset")
- `status`: Message status, either good (green), warning (amber), or attention (red) (default: "attention")
- `minimal` : Send full message or minimal. True of False (default: "false")

## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
    - name: Send Teams channel notification on failure
      if: failure()
      uses: DFE-Digital/github-actions/send-to-teams-channel@master
      with:
        teams-webhook-url: ${{ secrets.TEAMS_WEBHOOK_URL }}
        title: Cluster smoke test
        service: My service
        status: warning
        minimal: true
        message: |
          smoke test failed for cluster $${{ env.CLUSTER_NAME }}
          Check cluster status
```
