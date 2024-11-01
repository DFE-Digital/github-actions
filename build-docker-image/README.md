# Build docker image

Build the docker image, with or without cache and push to the Github container registry. If the package does not exist yet, it will create it and
configure permissions and visibility automatically. For more information, read the [Github documentation](https://docs.github.com/en/packages/managing-github-packages-using-github-actions-workflows/publishing-and-installing-a-package-with-github-actions).

It creates 2 tags:
- Commit SHA to identify this build uniquely
- Branch name to allow reusing the cached layers from the registry

If caching is enabled via reuse-cache, the caching used depends on the setting of max-cache
- max-cache = false, (default) then it will use inline caching (min level). Cache of the final stage only is exported with the image,
  see https://docs.docker.com/build/cache/backends/inline/ and it will use the docker build driver https://docs.docker.com/build/builders/drivers/docker/
- max-cache = true, then it will use registry caching (max level). Cache for all stages is exported separate to the image,
  see https://docs.docker.com/build/cache/backends/registry/ and it will use the docker-container build driver https://docs.docker.com/build/builders/drivers/docker-container/

max-cache=true is preferred for multi-stage builds.

Note that the cache hit ratio for a workflow running build can be seen on the workflow summary page.

Optionally (recommended) scan the image for vulnerabilities using [Snyk](https://snyk.io/).

A service that uses this action with reuse-cache = true, should also have a cache refresh workflow that has reuse-cache = false that runs weekly and on-demand. This is required to refresh the underlying cache so it picks up any underlying image changes.

## Inputs
- `github-token`: Default Github token retrieved via secrets. GITHUB_TOKEN or PAT with permission to the repository (Required)
- `snyk-token`: Snyk token for image vulnerability scanning (Default = none)
- `reuse-cache`: Use previously built docker image layers to improve build time. Set to false to refresh image (Default = true)
- `dockerfile-path`: Relative path to the Dockerfile (Default = ./Dockerfile)
- `context`: Path used as file context for Docker. If not set, the git repository is cloned using the same git reference as the workflow and used as context.
- `target`: The target stage to build of a multi-stage build
- `docker-repository`: Repository name in the container registry. e.g. ghcr.io/dfe-digital/register-trainee-teachers. Defaults to current Github repository name.
- `max-cache`: Set to true to use maximum cache level when reuse-cache is set. Defaults to minimum (false)
- `slack-webhook`:  A slack webhook to send a slack message to the service tech channel. See https://technical-guidance.education.gov.uk/infrastructure/monitoring/slack/#content (Optional)

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
