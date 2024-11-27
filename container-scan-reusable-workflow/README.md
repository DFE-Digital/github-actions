# Container scanning with Trivy

Reusable workflows must be kept in the [.github/workflows](../.github/workflows) directory, find the trivy container scans reusable workflow at the link below: 

* [container scanning reusable workflow](../.github/workflows/reusable-workflow-container-scans.yml)

```yaml
      scan-type:
        description: The scan type you'd like to run. Options = fs or image
        required: true
        type: string
      registry:
        description: The container registry you use. Options = Dockerhub, github, artifactory, azure
        required: false
        type: string
        default: github
      image:
        description: The container image you wish to download you use. e.g. dfe-digital/get-into-teaching-frontend:release-build-sha-f7b65d6
        required: false
        type: string
        default: github
      create-sbom:
        description: Boolean, choose this if you wish to create an SBOM and upload it to artifacts
        required: false
        type: boolean
        default: false
      config-path:
        description: Path to trivy config file
        required: false
        type: string
```