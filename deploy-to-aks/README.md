# Deploy to AKS

Deploy a docker image by sha to a specific service environment.
Optionally after deployment
- run a seed command for review apps
  - if enabled, it will run 'make review seed-review-app' so this must exist in the Makefile
- run a smoktest after deployment

If using Google Cloud then GCP_PROJECT_ID abd GCP_WIP variables must be set in the service Makefile.

## Inputs
- `azure-credentials`: A JSON string containing service principal credentials (Required)
- `gcp-wip`: The full identifier of the GCP Workload Identity Provider. See https://github.com/DFE-Digital/terraform-modules/blob/main/aks/dfe_analytics/README.md#authentication---github-actions (Optional)
- `gcp-project-id`: The name of the GCP Project ID. See https://github.com/DFE-Digital/terraform-modules/blob/main/aks/dfe_analytics/README.md#authentication---github-actions (Optional)
- `environment`: Name of the environment to deploy (Required)
- `pr-number`: Pull Request Number if deploying a review app (Optional)
- `db-seed`: Run seed command after a deployment. Should only be used for review apps (default: false)
- `sha`: Commit sha corresponding to the docker image tag to be deployed (Required)
- `slack-webhook` : A slack webhook to send a slack message to the service tech channel on deploy failure. See https://technical-guidance.education.gov.uk/infrastructure/monitoring/slack/#content (Optional)
- `smoke-test` : Run an application smoke test after deployment (default: false)
- `healthcheck` : Health check path, without first / e.g. 'healthcheck/all' (Optional)
- `terraform-base` : Name of the base terraform path (default: 'terraform/application')

## Example

```yaml
- name: Deploy App to Review
  id: deploy_review
  uses: DFE-Digital/github-actions/deploy-to-aks@master
  with:
    azure-credentials:  ${{ secrets.AZURE_CREDENTIALS }}
    environment: review
    pr-number: ${{ github.event.pull_request.number }}
    sha: ${{ needs.build.outputs.docker-image-tag }}
    healthcheck: 'healthcheck/all'
    db-seed: true
    smoke-test: true
    gcp-wip: ${{ vars.GCP_WIP }}
    gcp-project-id: ${{ vars.GCP_PROJECT_ID }}
```