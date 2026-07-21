# Fix Airbyte lsn

Workflow to resolve "Saved offset is before replication slot's confirmed lsn" errors for an Airbyte sync

## Inputs
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `namespace`: Kubernetes namespace where Airbyte is deployed (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `connection-id`: Airbyte connection UUID to reset state for
- `dry-run`: If true, inspect state only — do not delete

## Examples

```yaml
- name: Fix Airbyte LSN state
  uses: DFE-Digital/github-actions/fix-airbyte-lsn@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    namespace: ${{ env.NAMESPACE }}
    cluster: ${{ env.CLUSTER }}
    connection-id: ${{ env.CONNECTION_ID }}
    dry-run: ${{ env.DRY_RUN }}
```
