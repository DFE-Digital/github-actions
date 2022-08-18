# CheckServicePrincipal

### Purpose
The Service Principal giving access to the Azure Secrets can expire, and there needs to be a method to allow the users to check this and action it before the system stops.

### Access Permissions
To check the Azure Active Directory entry the Github_Action needs the Service Principal to be granted Directory.Read.All at Application level in the API Permissions of the Service Principal. This will require a Service Now ticket for the [CIP team](https://technical-guidance.education.gov.uk/infrastructure/support/#cip-engineering).

## Input Parameters

### AzureCredentials
Mandatory string containing the Azure Credentials of the user which will carry out the check.

### ServicePrincipal:
Mandatory string representing Service Principal you want to check

### ExpiresWithinDays:
Optional integer representing the time period in days you wish to check for keys that may expire. Defaults to 30.

### TenantName:
Optional string containing the tenant name, defaults to 'platform.education.gov.uk'

## Outputs

### json_data
Result in JSON format

## Example


```
name: Check Service Principal

on:
  workflow_dispatch:
  schedule:
    - cron: "35 6 * * *"

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: DFE-Digital/github-actions/CheckServicePrincipal@main
        id:   kv
        with:
            AzureCredentials: ${{ secrets.AZURE_CREDENTIALS }}
            ServicePrincipal: s146d01-keyvault-readonlyaccess

     - name: Display
       run: echo ${{steps.kv.outputs.json_data}}
```
