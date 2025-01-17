# Deploy Domains Environment

Deploy the Environment Domains

## Inputs
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `environment`: the name of the environment for the domains (Required)
- `healthcheck` : Health check path, without first / e.g. 'healthcheck/all' (Optional)
- `slack-webhook` : A slack webhook to send a slack message to the service tech channel on deploy failure. See https://technical-guidance.education.gov.uk/infrastructure/monitoring/slack/#content (Optional)
- `terraform-base` : Name of the base terraform path (default: 'terraform/domains/environment')

## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
      - name: Deploy Domains Environment
        id: deploy_domains_env
        uses: DFE-Digital/github-actions/deploy-domain-env@master
        with:
          azure-client-id:  ${{ secrets.AZURE_CLIENT_ID  }}
          azure-tenant-id:  ${{ secrets.AZURE_TENANT_ID   }}
          azure-subscription-id:  ${{ secrets.AZURE_SUBSCRIPTION_ID   }}
          environment: test
          healthcheck: healthcheck/all
          slack-webhook: ${{ secrets.SLACK_WEBHOOK }}
          terraform-base: terraform/domains/environment
```
