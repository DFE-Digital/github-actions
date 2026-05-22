# Review App Reconcile

Review App Reconcile
- determines which running review deployments are stale (associated PR is not open)
- deletes the stale deployments via a looped call to delete review app github action*

*only if dry_run is set to false


## Inputs
- `azure-client-id`: Azure service principal or managed identity client ID when using OIDC
- `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC
- `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC
- `resource-group-name`: Azure resource group (Required)
- `storage-account-name`: Azure storage account containing terraform state file (Required)
- `gcp-wip`: The full identifier of the GCP Workload Identity Provider. See https://github.com/DFE-Digital/terraform-modules/blob/main/aks/dfe_analytics/README.md#authentication---github-actions (Optional)
- `gcp-project-id`: The name of the GCP Project ID. See https://github.com/DFE-Digital/terraform-modules/blob/main/aks/dfe_analytics/README.md#authentication---github-actions (Optional)
- `terraform-base`: Name of the base terraform path (default: 'terraform/application')
- `service-name`: name of the service e.g. cpd-ec2 (as per service_name passed to application.tf) (Required)
- `github-token`: github token that can push the maintenance image to the docker repository (Required)
- `github-repo`: name of the github project e.g DFE-Digital/npq-registration (Required)
- `tf-vars-path` : path to tenant code directory containing environment vars  default: ("terraform/application")
- `global-config-path`: path to tenant code driectory containing global config parameter files  (default: "config/global_config")  (Required)


## Example

```

name: Reconcile review apps on AKS

on:
  workflow_dispatch:
    inputs:
      dry_run:
        description: "Only display stale review apps; do not delete"
        required: true
        default: true
        type: boolean
  # schedule:
  #   - cron: "0 */6 * * *"

permissions:
  id-token: write
  pull-requests: write
  contents: read

env:
  GLOBAL_CONFIG_PATH: config/global_config
  TF_VARS_PATH: config/terraform/application/config
  TERRAFORM_BASE: config/terraform/application
  SERVICE_NAME: cpd-ec2
  RESOURCE_GROUP_NAME: s189t01-cpdec2-rv-rg
  STORAGE_ACCOUNT_NAME: s189t01cpdec2rvtfsa
  CONTAINER_NAME: terraform-state

jobs:
  display-review-apps-to-remove:
    name: Reconcile review apps
    runs-on: ubuntu-latest

    environment: review

    outputs:
      stale_prs: ${{ steps.reconcile.outputs.stale_prs }}

    steps:
      - name: Checkout
        uses: actions/checkout@v6
        with:
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Reconcile review apps
        id: reconcile
        uses: DFE-Digital/github-actions/review-app-reconcile@2689-check-delete-review-app
        with:
          azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
          azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          resource-group-name: ${{ env.RESOURCE_GROUP_NAME }}
          storage-account-name: ${{ env.STORAGE_ACCOUNT_NAME }}
          terraform-base: ${{ env.TERRAFORM_BASE }}
          service-name: ${{ env.SERVICE_NAME }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
          github-repo: ${{ github.repository }}
          tf-vars-path: ${{ env.TF_VARS_PATH }}
          global-config-path: ${{ env.GLOBAL_CONFIG_PATH }}

  delete-review-apps-after-reconcile:
     name: Delete review app ${{ matrix.pr_number }} after reconcile
     needs: display-review-apps-to-remove
     runs-on: ubuntu-latest
     environment: review

     if: >
       github.event.inputs.dry_run == 'false' &&
       needs.display-review-apps-to-remove.outputs.stale_prs != '[]'

     strategy:
       fail-fast: false
       matrix:
         pr_number: ${{ fromJson(needs.display-review-apps-to-remove.outputs.stale_prs) }}

     concurrency: deploy_review_${{ matrix.pr_number }}

     steps:
       - name: Checkout
         uses: actions/checkout@v6
         with:
           token: ${{ secrets.GITHUB_TOKEN }}

       - name: Delete stale review app
         uses: DFE-Digital/github-actions/delete-review-app@master
         with:
           azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
           azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
           azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
           terraform-base: ${{ env.TERRAFORM_BASE }}
           gcp-wip: ${{ vars.GCP_WIP }}
           gcp-project-id: ${{ vars.GCP_PROJECT_ID }}
           pr-number: ${{ matrix.pr_number }}
           resource-group-name: ${{ env.RESOURCE_GROUP_NAME }}
           storage-account-name: ${{ env.STORAGE_ACCOUNT_NAME }}
           container-name: ${{ env.CONTAINER_NAME }}
           tf-state-file: review-${{ matrix.pr_number }}_kubernetes.tfstate
```
