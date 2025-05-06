# Delete Review App

Delete a review app.
- terraform destroy the resources
- delete terraform state file and all previous versions

If using Google Cloud then GCP_PROJECT_ID abd GCP_WIP variables must be set in the service Makefile.

## Inputs
- `azure-credentials`: A JSON string containing service principal credentials (Required)
- `container-name`: Azure container-name containing terraform state file (default: "terraform-state")
- `gcp-wip`: The full identifier of the GCP Workload Identity Provider. See https://github.com/DFE-Digital/terraform-modules/blob/main/aks/dfe_analytics/README.md#authentication---github-actions (Optional)
- `gcp-project-id`: The name of the GCP Project ID. See https://github.com/DFE-Digital/terraform-modules/blob/main/aks/dfe_analytics/README.md#authentication---github-actions (Optional)
- `pr-number`: Pull Request Number of review app (Required)
- `resource-group-name`: Azure resource group (Required)
- `storage-account-name`: Azure storage account containing terraform state file (Required)
- `terraform-base` : Name of the base terraform path (default: 'terraform/application')
- `tf-file` : name of the file containing the terraform version (default: "terraform.tf")
- `tf-state-file`: name of file containing terraform state (Required)

## Example

```yaml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
    - name: Set environment variables
      shell: bash
        run: |
          source global_config/review.sh
          echo "AZURE_RESOURCE_PREFIX=${AZURE_RESOURCE_PREFIX}" >> $GITHUB_ENV
          echo "CONFIG_SHORT=${CONFIG_SHORT}" >> $GITHUB_ENV

    - name: Delete Review App
      id: delete-review-app
      uses: DFE-Digital/github-actions/delete-review-app@master
      with:
        azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
        container-name: terraform-state
        gcp-wip: ${{ vars.GCP_WIP }}
        gcp-project-id: ${{ vars.GCP_PROJECT_ID }}
        pr-number: ${{ github.event.pull_request.number }}
        resource-group-name: "${{ env.AZURE_RESOURCE_PREFIX }}-#SERVICE_SHORT#-${{ env.CONFIG_SHORT }}-rg"
        storage-account-name: "${{ env.AZURE_RESOURCE_PREFIX }}#SERVICE_SHORT#${{ env.CONFIG_SHORT }}tfsa"
        tf-state-file: "${{ env.PR_NUMBER }}_kubernetes.tfstate"
```
