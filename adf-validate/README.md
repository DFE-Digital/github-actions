# Validate and Export ADF

Validates ADF configuration
e.g.

```yaml

```

## Inputs
- `github-token`: Default Github token retrieved via secrets. GITHUB_TOKEN or PAT with permission to the repository (Required)


## Outputs
- `tag`: Tag uniquely generated for this build (Currently long commit SHA)
- `image`: Reference to the built image suitable for use by Kubernetes (the docker repository combined with the tag)

## Example

```yaml
- uses: actions/checkout@v4

- name: Build and push docker image
  uses: DFE-Digital/github-actions/build-docker-image@master
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```
