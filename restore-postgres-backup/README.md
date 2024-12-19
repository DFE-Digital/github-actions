# Restore Postgres Backup

Restore an Azure Postgresql server database from a previous backup that is stored in an Azure storage account
Mainly designed to be used in DR and DR test procedures

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs
- `storage-account`: Name of the Azure atorage account that contains the backup (Required)
- `resource-group`: Azure resource group of the storage account (Required)
- `app-name`: Name of the aks app deployment (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `backup-file`: Name of the source backup file that is being restored (Required)

## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
      - name: Restore postgres backup
        uses: DFE-Digital/github-actions/restore-postgres-backup@master
        with:
          storage-account: myserviceqabkpsa
          resource-group: s189t01-app-rg
          app-name: myservice-qa
          cluster: test
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          backup-file: backup290224
```
