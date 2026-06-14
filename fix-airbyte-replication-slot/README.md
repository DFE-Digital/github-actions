# Fix Airbyte replication slot

Workflow to recreate the Airbyte replication slot if it has been dropped

## Inputs
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `airbyte-app-name`: Name of the aks app deployment (Required)
- `namespace`: Kubernetes namespace where Airbyte is deployed (Required)
- `cluster`: AKS cluster to use, test or production (Required)
- `connection-id`: Airbyte connection UUID to reset state for
- `dry-run`: If true, inspect state only — do not delete

## Examples

```yaml
- name: Fix Airbyte replication slot
  uses: DFE-Digital/github-actions/fix-airbyte-replication-slot@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    app-name: ${{ env.SERVICE_NAME }}-${{ env.DEPLOY_ENV }}
    namespace: ${{ env.NAMESPACE }}
    cluster: ${{ env.CLUSTER }}
    dry-run: ${{ env.DRY_RUN }}
```
