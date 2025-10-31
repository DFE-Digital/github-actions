# validate-infra

GitHub Action to validate infrastructure state by running terraform plan with detailed exit codes to detect configuration drift.

## Purpose

This action runs `terraform plan` with the `-detailed-exitcode` flag to detect when deployed infrastructure has drifted from the expected state defined in terraform code. It validates three types of infrastructure sequentially:

1. **AKS Cluster Infrastructure** - Core cluster resources
2. **Domains Environment Infrastructure** - Environment-specific domain resources
3. **Domains Infrastructure** - Shared domain infrastructure

The action is designed to be used in scheduled workflows to continuously validate infrastructure compliance.

## How It Works

The action sets the `DETAILED_EXITCODE=-detailed-exitcode` environment variable before running three make targets:
- `make ci ${{ environment }} terraform-plan` - AKS cluster validation
- `make ci ${{ environment }} domains-plan` - Domains environment validation
- `make ci domains-infra-plan` - Domains infrastructure validation

Your Makefile's terraform plan commands should use `${DETAILED_EXITCODE}` to include this flag when set. All three validations run sequentially, and each reports drift status independently.

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
| `terraform-version-file`| Name of file containing terraform version                      | No       | `terraform.tf`                  |
| `slack-webhook`         | Slack webhook URL for notifications                            | No       | -                               |

## Outputs

| Output                       | Description                                                                             |
| ---------------------------- | --------------------------------------------------------------------------------------- |
| `cluster_drift_detected`     | Whether AKS cluster infrastructure drift was detected (`true`, `false`, or `error`)     |
| `domains_env_drift_detected` | Whether domains environment infrastructure drift was detected (`true`, `false`, or `error`) |
| `domains_infra_drift_detected` | Whether domains infrastructure drift was detected (`true`, `false`, or `error`)       |

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
- Your Makefile must define the following targets that use `${DETAILED_EXITCODE}` variable:
  - `terraform-plan` - AKS cluster validation
  - `domains-plan` - Domains environment validation
  - `domains-infra-plan` - Domains infrastructure validation
- The `ci` and environment targets must be defined in your Makefile
- (Optional) Slack webhook for notifications

### Example Makefile Targets

```makefile
terraform-plan:
	terraform -chdir=$(TERRAFORM_PATH) plan $(DETAILED_EXITCODE)

domains-plan:
	terraform -chdir=terraform/domains/environment_domains plan $(DETAILED_EXITCODE)

domains-infra-plan:
	terraform -chdir=terraform/domains/infrastructure plan $(DETAILED_EXITCODE)
```

## Related Actions

- [deploy-to-aks](../deploy-to-aks) - Deploy to AKS environment
- [deploy-domains-infra](../deploy-domains-infra) - Deploy domains infrastructure
- [set-arm-environment-variables](../set-arm-environment-variables) - Set ARM environment variables
- [set-kubelogin-environment](../set-kubelogin-environment) - Set up kubelogin for AKS authentication

