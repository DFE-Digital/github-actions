# Set kubelogin environment

[kubelogin](https://azure.github.io/kubelogin/) is required for authentication to AKS cluster with Azure RBAC. It relies on environment variables to use a service principal.

This action uses [set-arm-environment-variables](../set-arm-environment-variables/README.md) to sets the environment variables suitable for running Terraform, adds the kubelogin specific variables, and sets up kubelogin itself.

## Inputs

- `azure-credentials` - A JSON string containing service principal credentials.

## Example

```yaml
- name: Set kubelogin environment
  uses: DFE-Digital/github-actions/set-kubelogin-environment@master
  with:
    azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
```
