# Validate and Export ADF

Validates ADF configuration and optionally exports it as an artifact. Uses MS's [Azure Data Factory utilities](https://www.npmjs.com/package/@microsoft/azure-data-factory-utilities). This will need to be run against ADFs collaboration branch, typically main.

>Note: [Azure Data Factory utilities](https://www.npmjs.com/package/@microsoft/azure-data-factory-utilities) expects Node.js version 20.x which is [EOL](https://nodejs.org/en/about/previous-releases), via this action its set to run with Node.js 26.x and has worked as expected for testing but be aware.

>WARNING: Ensure no secrets or sensitive information is stored as part of ADF configuration, eg DO NOT save access keys used to access a storage account or database credentials, these should be stored in a vault.

See [Continuous deployment improvements](https://learn.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery-improvements#continuous-deployment-improvements) for information on validation and export.
See [Best practices for CI/CD](https://learn.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery#best-practices-for-cicd)

## Inputs

  - `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"} (Optional)
  - `azure-client-id`: Azure service principal or managed identity client ID when using OIDC (Optional)
  - `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC (Optional)
  - `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC (Optional)
  - `adf-path`: Relative path to the ADF directory (Default = ./adf)
  - `adf-export-path`: Relative path to the export directory (Default = ./export)
  - `adf-resource-id`: Azure Data Factory resource ID (Required)
  - `adf-validate-only`: description: Flag to indicate whether to only validate the ADF files without exporting (Default = false)

## Outputs
  - `adf-export-url`: RL of the exported ADF files


## Example
### Validate and then export ADF
```yaml
    - name: Export ADF
      id: export-adf
      uses: DFE-Digital/github-actions/adf-validate-and-export@2841-adf-actions
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        adf-path: ./adf
        adf-resource-id: ${{ inputs.adf_resource_id }}
        adf-export-path: ./adf-export
        azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
        azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```

### Validate ADF only
```yaml
    - name: Validate ADF
      id: export-adf
      uses: DFE-Digital/github-actions/adf-validate-and-export@2841-adf-actions
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        adf-path: ./adf
        adf-resource-id: ${{ inputs.adf_resource_id }}
        adf-export-path: ./adf-export
        azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
        azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```
