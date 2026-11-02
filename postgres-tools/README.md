# PostgreSQL Tools

Create, list and restore PostgreSQL backups using a temporary db-tools pod running inside AKS.

The action creates a temporary PostgreSQL tools pod in the target AKS cluster, performs the requested operation, and then removes the pod when complete.

Supported operations:

- `backup` - Create a PostgreSQL backup and upload it to Azure Blob Storage
- `list-backups` - List available backup files in Azure Blob Storage
- `restore` - Restore a backup to the service's configured PostgreSQL database
- `restore-custom` - Restore a backup to a specified PostgreSQL server and database

## OIDC

Federated credentials must be set up to allow the action to authenticate to Azure and Kubernetes.

The calling workflow must grant:

```yaml
permissions:
  id-token: write
```

## Inputs

- `operation`: Operation to perform (`backup`, `list-backups`, `restore` or `restore-custom`) (Required)
- `azure-client-id`: Azure service principal or managed identity client ID (Required)
- `azure-subscription-id`: Azure subscription ID (Required)
- `azure-tenant-id`: Azure tenant ID (Required)
- `service-name`: Service deployment name (Required)
- `service-short`: Short service code used when constructing storage account names (Required)
- `environment`: Application environment (Required)
- `tf-vars-path`: Path containing the environment tfvars files (Required)
- `resource-prefix`: Azure resource prefix. This is derived from the environment configuration.
- `restore-file`: Backup file to restore (Required for `restore` and `restore-custom`)
- `destination-server`: Target PostgreSQL server hostname (Required for `restore-custom`)
- `destination-database`: Target PostgreSQL database name (Required for `restore-custom`)

## Example - Backup

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        required: true
        default: qa
        type: choice
        options:
          - qa
          - staging
          - production

  schedule:
    - cron: "50 5 * * *" # 05:50 UTC

permissions:
  id-token: write

env:
  SERVICE_NAME: example_service_name
  SERVICE_SHORT: esn
  TF_VARS_PATH: terraform/application/config

jobs:
  backup:
    runs-on: ubuntu-latest

    environment:
      name: ${{ inputs.environment }}

    steps:
      - uses: actions/checkout@v7

      - uses: azure/login@v3
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - uses: DFE-Digital/github-actions/postgres-tools@master
        with:
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          operation: backup
          service-name: ${{ env.SERVICE_NAME }}
          service-short: ${{ env.SERVICE_SHORT }}
          environment: ${{ inputs.environment }}
          tf-vars-path: ${{ env.TF_VARS_PATH }}
```

## Example - List Backups

```yaml
- uses: DFE-Digital/github-actions/postgres-tools@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    operation: list-backups
    service-name: ${{ env.SERVICE_NAME }}
    service-short: ${{ env.SERVICE_SHORT }}
    environment: ${{ inputs.environment }}
    tf-vars-path: ${{ env.TF_VARS_PATH }}
```

## Example - Restore

```yaml
- uses: DFE-Digital/github-actions/postgres-tools@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    operation: restore
    service-name: ${{ env.SERVICE_NAME }}
    service-short: ${{ env.SERVICE_SHORT }}
    environment: ${{ inputs.environment }}
    tf-vars-path: ${{ env.TF_VARS_PATH }}
    restore-file: postgres-backup-2026-11-03_055001.sql
```

## Example - Custom Restore

```yaml
- uses: DFE-Digital/github-actions/postgres-tools@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    operation: restore-custom
    service-name: ${{ env.SERVICE_NAME }}
    service-short: ${{ env.SERVICE_SHORT }}
    tf-vars-path: ${{ env.TF_VARS_PATH }}
    restore-file: postgres-backup-2026-11-03_055001.sql
    destination-server: target-postgres-server
    destination-database: target_restore_db
```

### Notes

- Backups are stored in the `database-backup` Azure Blob Storage container.
- The action automatically creates and removes a temporary db-tools pod for each operation.
- The action discovers the application's database connection details from the deployment's configured secrets.
- For `restore-custom`, the destination server and database must already exist.