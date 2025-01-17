# Deploy Domains Infrastructure

Deploy the infrastructure Domains

## Inputs
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `slack-webhook` : A slack webhook to send a slack message to the service tech channel on deploy failure. See https://technical-guidance.education.gov.uk/infrastructure/monitoring/slack/#content (Optional)
- `terraform-base` : Name of the base terraform path (default: 'terraform/domains/infrastructure')

## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
      - name: Deploy Domains Infrastructure
        id: deploy_domains_infra
        uses: DFE-Digital/github-actions/deploy-domain-infra@master
        with:
          azure-client-id:  ${{ secrets.AZURE_CLIENT_ID  }}
          azure-tenant-id:  ${{ secrets.AZURE_TENANT_ID   }}
          azure-subscription-id:  ${{ secrets.AZURE_SUBSCRIPTION_ID   }}
          slack-webhook: ${{ secrets.SLACK_WEBHOOK }}
          terraform-base: terraform/domains/infrastructure
```
