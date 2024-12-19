# Back up Postgres

Back up an Azure Postgresql server database and upload the backup file to an Azure storage account
Designed for scheduled backups as well as disaster recovery procedures

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs
- `storage-account`: Name of the Azure storage account for the backup (Required)
- `resource-group`: Azure resource group of the storage account (Required)
- `app-name`: Name of the aks app deployment (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `backup-file`: Name of the backup file. The file will be compressed and the .gz extension added to this name. (Required)
- `slack-webhook`: A slack webhook to send a slack message to the service tech channel (Required)
- `db-server-name` : Alternate database server (Optional)

## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:

      - name: Backup postgres
        uses: DFE-Digital/github-actions/backup-postgres@master
        with:
          storage-account: myserviceqabkpsa
          resource-group: s189t01-app-rg
          app-name: myservice-qa
          cluster: test
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          backup-file: backup290224.sql
          slack-webhook: ${{ env.slack-webhook }}
```
