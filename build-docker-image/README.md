# Build docker image

Build the docker image, with or without cache and push to the Github container registry. If the package does not exist yet, it will create it and
configure permissions and visibility automatically. For more information, read the [Github documentation](https://docs.github.com/en/packages/managing-github-packages-using-github-actions-workflows/publishing-and-installing-a-package-with-github-actions).

It creates 2 tags:
- Commit SHA to identify this build uniquely
- Branch name to allow reusing the cached layers from the registry

Optionally (recommended) scan the image for vulnerabilities using [Snyk](https://snyk.io/).

## Inputs
- `github-token`: Default Github token retrieved via secrets. GITHUB_TOKEN or PAT with permission to the repository (Required)
- `snyk-token`: Snyk token for image vulnerability scanning (Default = none)
- `reuse-cache`: Use previously built docker image layers to improve build time. Set to false to refresh image (Default = true)
- `dockerfile-path`: Relative path to the Dockerfile (Default = ./Dockerfile)
- `context`: Path used as file context for Docker. If not set, the git repository is cloned using the same git reference as the workflow and used as context.
- `target`: The target stage to build of a multi-stage build
- `docker-repository`: Repository name in the container registry. e.g. ghcr.io/dfe-digital/register-trainee-teachers. Defaults to current Github repository name.

## Outputs
- `tag`: Tag uniquely generated for this build (Currently long commit SHA)
- `image`: Reference to the built image suitable for use by Kubernetes (the docker repository combined with the tag)

## Example

```yaml
- name: Build and push docker image
  uses: DFE-Digital/github-actions/build-docker-image@master
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```
