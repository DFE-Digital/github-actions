# Maintenance mode

Enable or disable maintenance mode for a service

The action relies on make commands defined in the [new_service template](https://github.com/DFE-Digital/teacher-services-cloud/tree/main/templates/new_service).

## OIDC
Federated credentials must be set up to allow the action to authenticate to Azure and kubernetes

## Inputs
- `environment`: Name of the app environment affected (Required)
- `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"}
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `mode`: Mode to set, either enable or disable (Required)
- `docker-repository`: full name of the docker repository for the maintenance image (Required)
- `github-token`: github token that can push the maintenance image to the docker repository (Required)

## Example

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        required: true
        type: choice
        options:
        - staging
        - production
      mode:
        required: true
        type: choice
        options:
        - enable
        - disable

jobs:
  set-maintenance-mode:
    name: Set maintenance mode
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Enable or disable maintenance mode
      uses: DFE-Digital/github-actions/maintenance@master
      with:
        azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
        azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        environment: ${{ inputs.environment }}
        mode: ${{ inputs.mode }}
        docker-repository: ghcr.io/dfe-digital/some-service-maintenance
        github-token: ${{ secrets.GITHUB_TOKEN }}
```
