# PTR Postgres

Perform a point in time restore of an existing Azure Postgresql server database.
Restore will be performed to a new server, and will not affect the current server in any way.
Mainly designed to be used in DR and DR test procedures

## Inputs
- `resource-group`: Azure resource group of the Azure database server (Required)
- `source-server`: Name of the Azure database server we are restoring from (Required)
- `new-server`: Name of the new Azure database server we are restoring to (Required)
- `restore-time`: restore point in time, format YYYY-MM-DDTHH:MM:SS e.g. 2024-07-24T06:00:00 (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principal credentials (Required)

## Example

```yaml
jobs:
  main:
    runs-on: ubuntu-latest
    steps:

      - name: PTR postgres
        uses: DFE-Digital/github-actions/ptr-postgres@master
        with:
          resource-group: s189t01-app-rg
          source-server: s189t01-db
          new-server: s189t01-db-new
          restore-time: 2024-07-24T06:00:00
          cluster: test
          azure-credentials: ${{ secrets.AZURE_CREDENTIALS}}
```
