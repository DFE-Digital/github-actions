# Set kubelogin environment

[kubelogin](https://azure.github.io/kubelogin/) is required for authentication to AKS cluster with Azure RBAC. It relies on environment variables to use a service principal.

This action uses [set-arm-environment-variables](../set-arm-environment-variables/README.md) to set the environment variables suitable for running Terraform, adds the kubelogin specific variables, and installs kubelogin itself.

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs

- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC

## Example

```yaml
- name: Set kubelogin environment
  uses: DFE-Digital/github-actions/set-kubelogin-environment@master
  with:
    azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
    azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
    azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```
