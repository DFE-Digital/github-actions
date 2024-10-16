# Maintenance mode

Enable or disable maintenance mode for a service

## Inputs
- `environment`: Name of the app environment affected (Required)
- `azure-credentials`: A JSON string containing service principle credentials (Required)
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

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Enable or disable maintenance mode
      uses: DFE-Digital/github-actions/maintenance@master
      with:
        azure-credentials: ${{ secrets.AZURE_CREDENTIALS}}
        environment: ${{ inputs.environment }}
        mode: ${{ inputs.mode }}
        docker-repository: ghcr.io/dfe-digital/some-service-maintenance
        github-token: ${{ secrets.GITHUB_TOKEN }}
```
