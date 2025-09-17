# validate-infra

GitHub Action to validate infrastructure state by running terraform plan with detailed exit codes to detect configuration drift.

## Purpose

This action runs `terraform plan` with the `-detailed-exitcode` flag to detect when deployed infrastructure has drifted from the expected state defined in terraform code. It's designed to be used in scheduled workflows to continuously validate infrastructure compliance.

## How It Works

The action sets the `DETAILED_EXITCODE=-detailed-exitcode` environment variable before running `make ci ${{ environment }} terraform-plan`. Your Makefile's terraform plan commands should use `${DETAILED_EXITCODE}` to include this flag when set.

## Usage

### Basic Usage

```yaml
- name: Validate infrastructure
  uses: DFE-Digital/github-actions/validate-infra@main
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    environment: production
    slack-webhook: ${{ secrets.SLACK_WEBHOOK }}
```

## Inputs

| Input                   | Description                                                    | Required | Default                         |
| ----------------------- | -------------------------------------------------------------- | -------- | ------------------------------- |
| `azure-client-id`       | Azure service principal or managed identity client ID for OIDC | No       | -                               |
| `azure-subscription-id` | Azure subscription ID for OIDC                                 | No       | -                               |
| `azure-tenant-id`       | Azure tenant ID for OIDC                                       | No       | -                               |
| `environment`           | Environment to validate (test, platform-test, production)      | Yes      | -                               |
| `terraform-main-ref`    | Git ref (branch/tag/SHA) to use for terraform code             | No       | `main`                          |
| `terraform-base`        | Path to the terraform files                                    | No       | `cluster/terraform_aks_cluster` |
| `slack-webhook`         | Slack webhook URL for notifications                            | No       | -                               |

## Outputs

| Output            | Description                                                             |
| ----------------- | ----------------------------------------------------------------------- |
| `drift_detected`  | Whether infrastructure drift was detected (`true`, `false`, or `error`) |
| `plan_output`     | The complete terraform plan output                                      |
| `changes_summary` | Summary of detected changes                                             |

## Exit Codes

The action interprets terraform plan exit codes as follows:

- `0`: No changes - infrastructure matches configuration
- `1`: Error occurred during plan
- `2`: Changes detected - infrastructure has drifted

## Example Scheduled Workflow

```yaml
name: Infrastructure Validation

on:
  schedule:
    - cron: "0 2 * * *" # Daily at 2 AM UTC
  workflow_dispatch:
    inputs:
      environment:
        description: "Environment to validate"
        type: choice
        options: [test, production]

jobs:
  validate:
    runs-on: ubuntu-latest
    permissions:
      id-token: write # Required for OIDC authentication
      contents: read
    steps:
      - name: Validate infrastructure
        id: validate
        uses: DFE-Digital/github-actions/validate-infra@main
        with:
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          environment: ${{ github.event.inputs.environment || 'production' }}
          slack-webhook: ${{ secrets.SLACK_WEBHOOK }}
```

## Requirements

- Azure service principal configured for OIDC authentication with GitHub
- Your Makefile's terraform plan commands must use `${DETAILED_EXITCODE}` variable
- The `ci` and environment targets must be defined in your Makefile
- (Optional) Slack webhook for notifications

## Related Actions

- [deploy-to-aks](../deploy-to-aks) - Deploy to AKS environment
- [deploy-domains-infra](../deploy-domains-infra) - Deploy domains infrastructure
- [set-arm-environment-variables](../set-arm-environment-variables) - Set ARM environment variables
- [set-kubelogin-environment](../set-kubelogin-environment) - Set up kubelogin for AKS authentication

