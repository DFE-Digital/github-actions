# Send Project Issues to Teams

Build a GitHub ProjectV2 issue summary and send it to a Microsoft Teams channel as an Adaptive Card.

This action handles:

- Querying issues from the current repository in a specified ProjectV2
- Filtering by label, status, and sprint
- Optionally including recently closed issues
- Sending a formatted card to Teams

## Inputs

- `github-token`: GitHub token with permission to read project and issue data. Required.
- `teams-webhook-url`: Teams webhook URL (Power Automate/Incoming Webhook). Required.
- `project-owner`: Organization/user that owns the ProjectV2. Optional. Default: `DFE-Digital`.
- `project-number`: ProjectV2 number. Required.
- `label-filter`: Only include issues with this label. Optional. Default: `Service Request`.
- `status-filter`: Optional status filter (matches project `Status` field). Optional. Default: empty.
- `sprint-filter`: Optional sprint filter (matches project `Sprint` field). Optional. Default: empty.
- `max-items`: Maximum number of issues to include. Optional. Default: `25`.
- `recently-closed-days`: Include issues closed within this many days (`0` disables). Optional. Default: `3`.
- `clickable-issue-links`: Render issue titles as clickable links in the card (`true`/`false`). Optional. Default: `false`.
- `send-when-empty`: Send the report even when no issues match (`true`/`false`). Optional. Default: `false`.

## Outputs

- `issue-count`: Number of matching issues found.
- `body-json`: Adaptive Card `body` JSON that was generated.

## Required Permissions

Set permissions in the calling workflow/job:

```yaml
permissions:
  contents: read
  issues: read
  repository-projects: read
```

Composite actions cannot define workflow/job permissions themselves.

## Example

```yaml
jobs:
  send-summary:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      issues: read
      repository-projects: read

    steps:
      - uses: actions/checkout@v4

      - name: Build and send project issue summary card
        uses: ./.github/actions/send-project-issues-to-teams
        with:
          github-token: ${{ secrets.ORG_PROJECT_READ_PAT }}
          teams-webhook-url: ${{ secrets.OPS_TRS_GITHUB_TEAMS_WEBHOOK_URL }}
          project-owner: DFE-Digital
          project-number: '85'
          label-filter: Service Request
          max-items: '25'
```

## Behaviour Notes

- Uses the current repository context for issue filtering.
- Sends nothing when no issues match (`issue-count` equals `0`) unless `send-when-empty` is enabled.
- Delegates Teams payload delivery to the local `send-adaptive-card-to-teams` action.
