# Back up Postgres

Back up an Azure Postgresql server database and upload the backup file to an Azure storage account
Designed for scheduled backups as well as disaster recovery procedures

## Inputs
- `storage-account`: Name of the Azure storage account for the backup (Required)
- `resource-group`: Azure resource group of the storage account (Required)
- `app-name`: Name of the aks app deployment (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principle credentials (Required)
- `backup-file`: Name of the backup file. The file will be compressed and the .gz extension added to this name. (Required)
- `slack-webhook`: A slack webhook to send a slack message to the service tech channel (Required)
- `db-server-name` : Alternate database server (Optional)

## Example

```yaml
jobs:
  main:
    runs-on: ubuntu-latest
    steps:

      - name: Backup postgres
        uses: DFE-Digital/github-actions/backup-postgres@master
        with:
          storage-account: myserviceqabkpsa
          resource-group: s189t01-app-rg
          app-name: myservice-qa
          cluster: test
          azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
          backup-file: backup290224.sql
          slack-webhook: ${{ env.slack-webhook }}
```
