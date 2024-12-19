# Set Azure Resource Manager environment variables

Sets the environment variables suitable for running Terraform. It also masks the environment variables.

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs

- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC

## Example

```yaml
- name: Set ARM environment variables
  uses: DFE-Digital/github-actions/set-arm-environment-variables@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```
