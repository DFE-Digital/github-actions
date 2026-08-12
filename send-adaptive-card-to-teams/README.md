# Send Adaptive Card to Teams

Post an Adaptive Card to a Microsoft Teams channel using a Teams webhook URL.

This action expects only the Adaptive Card `body` JSON. It builds the outer card envelope (`$schema`, `type`, `version`, `msteams`) for you.

## Inputs

- `teams-webhook-url`: Teams webhook URL (Power Automate/Incoming Webhook). Required.
- `body-json`: Adaptive Card `body` JSON array. Required.

## Outputs

This action does not define outputs.

## Permissions

Set permissions in the calling workflow/job. Composite actions cannot declare permissions.

## Example

```yaml
jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Send Adaptive Card
        uses: ./.github/actions/send-adaptive-card-to-teams
        with:
          teams-webhook-url: ${{ secrets.TEAMS_WEBHOOK_URL }}
          body-json: >-
            [
              {
                "type": "Container",
                "items": [
                  {
                    "type": "TextBlock",
                    "text": "Deployment complete",
                    "weight": "Bolder",
                    "size": "Medium"
                  },
                  {
                    "type": "TextBlock",
                    "text": "Service is healthy in production",
                    "wrap": true
                  }
                ]
              }
            ]
```

## Notes

- The action sends a Teams message payload with `application/vnd.microsoft.card.adaptive` content.
- Ensure webhook secrets are stored in repository or organization secrets.
