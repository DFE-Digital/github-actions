# Build docker image

Build the docker image, with or without cache and push to the Github container registry. It creates 2 tags:
- Commit SHA to identify this build uniquely
- Branch name to allow reusing the cached layers from the registry

Optionally (recommended) scan the image for vulnerabilities.

## Inputs
- `docker-repository`: Repository name in the container registry. e.g. ghcr.io/dfe-digital/register-trainee-teachers (Required)
- `github-token`: Default Github token retrieved via secrets.GITHUB_TOKEN or PAT with permission to the repository (Required)
- `snyk-token`: Snyk token for image vulnerability scanning (Default = none)
- `reuse-cache`: Use previously built docker image layers to improve build time. Set to false to refresh image (Default = true)
- `dockerfile-path`: Relative path to the Dockerfile (Default = ./Dockerfile)

## Example

```yaml
- name: Build and push docker image
  uses: DFE-Digital/github-actions/build-docker-image@master
  with:
    docker-repository: ghcr.io/dfe-digital/teacher-pay-calculator
    github-token: ${{ secrets.GITHUB_TOKEN }}
```
