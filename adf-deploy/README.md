# Deploy ADF

Deploys an ADF export into an existing ADF instance as specified by name and resource group. ADF export is expected to be an artifact produced by an earlier ADF-export job.

This utilises an MS script [PrePostDeploymentScript.Ver2.ps1](https://github.com/Azure/Azure-DataFactory/blob/main/SamplesV2/ContinuousIntegrationAndDelivery/PrePostDeploymentScript.Ver2.ps1) stop/ start triggers during release process. An instance of this script is included and used with this action to avoid breaking changes should the script be updated by MS (or we update). See [Sample pre- and post-deployment script](https://learn.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery-sample-script) for more details.

An `armTemplateParametersFile` will typically be provided reflecting resources that change between the source system and target system, and providing  resource IDs to use for the target system.

See [Use custom parameters with the Resource Manager template](https://learn.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery-resource-manager-custom-parameters)
See [Best practices for CI/CD](https://learn.microsoft.com/en-us/azure/data-factory/continuous-integration-delivery#best-practices-for-cicd)

## Inputs
  - `azure-credentials`: A JSON string containing service principal credentials e.g. {"client_id": "x", "client_secret": "x", "subscription_id": "x", "tenant_id": "x"} (Optional)
  - `azure-client-id`: Azure service principal or managed identity client ID when using OIDC (Optional)
  - `azure-subscription-id`: Azure service principal or managed identity subscription ID when using OIDC (Optional)
  - `azure-tenant-id`: Azure service principal or managed identity tenant ID when using OIDC (Optional)  
  - `resourceGroupName`: Data Factory resource group name (required)
  - `dataFactoryName`: Data factory name (required)
  - `armTemplateFile`: ARM template file name (default: 'ARMTemplateForFactory.json')
  - `armTemplateParametersFile`: ARM template parameters file name (default: 'ARMTemplateParametersForFactory.json')
  - `additionalParameters`: Parameters which will be replaced in the ARM template  (default: '')
  - `skipAzModuleInstallation`: Skip the Az module installation (default: 'true')

## Example
### Validate and then export ADF
```yaml
  deploy:
    name: Deploy ADF    
    permissions:
      id-token: write    
    needs: build
    environment:
      name: development    
    runs-on: ubuntu-latest    

    steps:
    - uses: actions/checkout@v7
      name: Checkout

    - name: Download ADF Export
      uses: actions/download-artifact@v8
      with:
        name: adf-export
        path: ./

    - name: Deploy ADF
      id: export-adf
      uses: DFE-Digital/github-actions/adf-deploy@2841-adf-actions
      with:
        github-token: ${{ secrets.GITHUB_TOKEN }}
        resourceGroupName: s189t01-eprdat-dv-rg
        dataFactoryName: s189t01-eprdat-development-rdg-import-adf
        armTemplateFile: ${{ github.workspace }}/ARMTemplateForFactory.json
        armTemplateParametersFile: ${{ github.workspace }}/ARMTemplateParametersForFactory.json
        skipAzModuleInstallation: false
        azure-client-id: ${{ secrets.AZURE_CLIENT_ID }}
        azure-subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
        azure-tenant-id: ${{ secrets.AZURE_TENANT_ID }}
```
