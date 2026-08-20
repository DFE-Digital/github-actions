# Konduit App Reconcile

Konduit App Reconcile
- Searches for deployments named konduit-app-nnnnn that are older than a configurable period in hours (default 48)

## Inputs

- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `cluster`: A single cluster or all 4 clusters
- `age-hours`: An integer of hours that the age of the deployment must be greater than


## Example

```

name: Reconcile Konduit Deployments

on:
  workflow_dispatch:
    inputs:
      cluster:
        description: Cluster to run against
        type: choice
        required: true
        default: all
        options:
          - all
          - s189t01-tsc-platform-test-aks
          - s189t01-tsc-test-aks
          - s189p01-tsc-production-aks

      dry_run:
        description: Only display stale deployments
        required: true
        default: true
        type: boolean

  schedule:
    - cron: "0 2 * * *"

permissions:
  id-token: write
  contents: read

jobs:
  find-and-delete-stale-konduit-deployments:
    runs-on: ubuntu-latest

    outputs:
      stale_deployments: ${{ steps.reconcile.outputs.stale_deployments }}

    strategy:
      fail-fast: false
      matrix:
        include:
          - cluster: s189t01-tsc-platform-test-aks
            environment: platform-test
          - cluster: s189t01-tsc-test-aks
            environment: test
          - cluster: s189p01-tsc-production-aks
            environment: production

    environment: ${{ matrix.environment }}

    steps:
      - uses: actions/checkout@v6
      - name: Get stale Konduit Deployments
        if: >
          github.event_name == 'schedule' ||
          github.event.inputs.cluster == 'all' ||
          github.event.inputs.cluster == matrix.cluster
        id: reconcile
        uses: DFE-Digital/github-actions/konduit-app-reconcile@master
        with:
          cluster: ${{ matrix.cluster }}
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          age-hours: 48

      - name: Report stale konduit deployments
        if: steps.reconcile.conclusion == 'success'
        run: |
          echo '${{ steps.reconcile.outputs.stale_deployments }}'

      - name: Delete stale konduit deployments
        env:
          DEPLOYMENTS: ${{ steps.reconcile.outputs.stale_deployments }}

        if: >
          steps.reconcile.conclusion == 'success' &&
          (
            github.event_name == 'schedule' ||
            github.event.inputs.dry_run != 'true'
          )
        run: |
          echo "$DEPLOYMENTS" | jq -c '.[]' | while read deployment; do
            name=$(echo "$deployment" | jq -r '.name')
            namespace=$(echo "$deployment" | jq -r '.namespace')
            echo "Deleting $name from $namespace"
            kubectl delete deployment "$name" -n "$namespace"
          done

      - name: Dry run message
        if: >
          github.event_name == 'workflow_dispatch' &&
          github.event.inputs.dry_run == true
        run: |
          echo "This is a dry run so no deployments have been deleted"

```
