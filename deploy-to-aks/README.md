# Deploy to AKS

Deploy a docker image by sha to a specific service environment.
Optionally after deployment
- run a seed command for review apps
- run a smoktest after deployment

## Inputs
- `azure-credentials`: A JSON string containing service principle credentials (Required)
- `environment`: Name of the environment to deploy (Required)
- `pr-number`: Pull Request Number if deploying a review app (Optional)
- `review-namespace`: Namespace for review apps (Optional)
- `review-prefix`: name of the review deployment, excluding the PR number (Optional)
- `seed-cmd`: command to run to see review apps (Optional)
- `sha`: commit sha of the docker image to be deployed (Required)
- `slack-webhook` : A slack webhook to send a slack message to the service tech channel on deploy failure (Optional)
- `smoketest-cmd` : Smoke test url path (Optional)
- `tf-url-output` : Name of the terraform url output, which must be json parsable (default: 'url')
- `tf-path` : Name of the base terraform path (default: 'terraform/application')

## Example

```yaml
- name: Checkout
  uses: actions/checkout@v4

- name: Deploy App to Review
  id: deploy_review
  uses: DFE-Digital/github-actions/deploy-to-aks@master
  with:
    azure-credentials:  ${{ secrets.AZURE_CREDENTIALS }}
    environment: review
    pr-number: ${{ github.event.pull_request.number }}
    review-prefix: teacher-service-pr
    review-namespace: srv-development
    sha: ${{ needs.build.outputs.docker-image-tag }}
    tf-path: ${{ env.TF_PATH }}
    smoketest-cmd: 'healthcheck/all'
    seed-cmd: 'cd /app && bundle exec rake db:seed'
```
