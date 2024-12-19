## Validate Key Vault secrets
This action runs the `fetch_config.rb` to validate that the secrets stored in Azure Key Vault are valid YAML.
[Usage](/.github/workflows/test-validate-key-vault-secrets.yml)

### Usage
```yml
jobs:
  main:
    ...
    permissions:
      id-token: write # Required for OIDC authentication to Azure
      ...

    steps:
    - uses: azure/login@v1
      with:
        client-id: ${{ inputs.azure-client-id }}
        tenant-id: ${{ inputs.azure-tenant-id }}
        subscription-id: ${{ inputs.azure-subscription-id }}

    - name: Validate Key Vault Secrets
      uses: DFE-Digital/github-actions/validate-key-vault-secrets@master
      with:
        KEY_VAULT: s121d01-shared-kv-01
        SECRETS: |
          BAT-INFRA-SECRETS-QA
          FIND-APP-SECRETS-QA
```
