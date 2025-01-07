# PTR Postgres

Perform a point in time restore of an existing Azure Postgresql server database.
Restore will be performed to a new server, and will not affect the current server in any way.
Mainly designed to be used in DR and DR test procedures

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs
- `resource-group`: Azure resource group of the Azure database server (Required)
- `source-server`: Name of the Azure database server we are restoring from (Required)
- `new-server`: Name of the new Azure database server we are restoring to (Required)
- `restore-time`: restore point in time, format YYYY-MM-DDTHH:MM:SS e.g. 2024-07-24T06:00:00 (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC


## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
      - name: PTR postgres
        uses: DFE-Digital/github-actions/ptr-postgres@master
        with:
          resource-group: s189t01-app-rg
          source-server: s189t01-db
          new-server: s189t01-db-new
          restore-time: 2024-07-24T06:00:00
          cluster: test
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```
