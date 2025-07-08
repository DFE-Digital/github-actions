# Recover Deleted Postgres

Restore a deleted postgres
Restore will be performed to a existing (deleted state) server with the same name
Mainly designed to be used to recover a postgres in DELETED state

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs
- `resource-group`: Azure resource group of the Azure database server (Required)
- `deleted-server`: Name of the new Azure database server we are restoring to (Required) from deleted state.
- `restore-time`: restore point in time, format YYYY-MM-DDTHH:MM:SS e.g. 2024-07-24T06:00:00 (Required). This time should be at least 10mins plus server deleted time
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
      - name: Recover Deleted Postgres
        uses: DFE-Digital/github-actions/restore-deleted-postgres@master
        with:
          resource-group: s189t01-app-rg
          deleted-server: s189t01-db-deleted
          restore-time: 2024-07-24T06:00:00
          cluster: test
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```
