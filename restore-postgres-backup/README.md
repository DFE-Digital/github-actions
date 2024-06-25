# Restore Postgres Backup

Restore an Azure Postgresql server database from a previous backup that is stored in an Azure storage account
Mainly designed to be used in DR and DR test procedures

## Inputs
- `storage-account`: Name of the Azure atorage account that contains the backup (Required)
- `resource-group`: Azure resource group of the storage account (Required)
- `app-name`: Name of the aks app deployment (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principle credentials (Required)
- `backup-file`: Name of the source backup file that is being restored (Required)

## Example

```yaml
jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      - name: Restore postgres backup
        uses: DFE-Digital/github-actions/restore-postgres-backup@master
        with:
          storage-account: myserviceqabkpsa
          resource-group: s189t01-app-rg
          app-name: myservice-qa
          cluster: test
          azure-credentials: ${{ secrets.AZURE_CREDENTIALS}}
          backup-file: backup290224
```
