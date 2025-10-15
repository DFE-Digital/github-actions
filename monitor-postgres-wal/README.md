# Monitor Postgres Logical Replication

If logical replication is enabled for a database, then we want to monitor the replication lag and drop the replication slot if it breaches a defined threshold

## Inputs
- `app-name`: Name of the aks app deployment (Required)
- `environment`: Name of the environment (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `slack-webhook`: A slack webhook to send a slack message to the service tech channel (Optional)
- `tf-vars-path` : terraform config file path (default: 'terraform/application/config')

## Requirements

WAL_THRESHOLD (number in bytes) must be set in each env.tfvars.json file.
It should be set to an acceptable size (in bytes) that won't fill the database available space if WAL used reaches this limit.
10000000000 (10G) is probably an acceptable default for most non-prod servers (depending on available space).
prod could require 2-3 times higher.

create a bin/stop-replication.psql in the calling repository that contains
```
\echo 'Wal used is high. Dropping replication slot.'
 ALTER ROLE CURRENT_USER WITH REPLICATION;
 select * from pg_drop_replication_slot('airbyte_slot');
 ALTER ROLE CURRENT_USER WITH NOREPLICATION;
```


## Examples

```yaml
on:
  schedule:
    - cron: "0 0,6,12,18 * * *"

permissions:
  id-token: write

env:
  SERVICE_NAME: register
  SERVICE_SHORT: rtt
  TF_VARS_PATH: terraform/aks/workspace-variables

jobs:
  monitor-wal-usage:
    name: Parallel postgres monitor
    environment:
      name: ${{ matrix.environment }}
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        environment: [qa, staging, production]
    steps:
    - name: Checkout
      uses: actions/checkout@v5

    - name: Monitor ${{ matrix.environment }}
      uses: DFE-Digital/github-actions/monitor-postgres-wal@master
      with:
        azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
        azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        environment: ${{ matrix.environment }}
        slack-webhook: ${{ secrets.SLACK_WEBHOOK }}
        app-name: ${{ env.SERVICE_NAME }}-${{ matrix.environment }}
        tf-vars-path: ${{ env.TF_VARS_PATH }}
```
