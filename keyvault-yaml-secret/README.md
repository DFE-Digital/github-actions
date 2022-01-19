## DEPRECATION WARNING: Use [keyvault-yaml-secret](https://github.com/DFE-Digital/keyvault-yaml-secret) which is more powerful and more secure

## Keyvault YAML secret


Extracts a single secret value from a YAML file stored in Azure key vault. The value is masked so it is never shown in the Gihub actions log.

The secret value is retrieved via output `secret-value`.

### Usage

```yml
- uses: azure/login@v1                                        # Login to Azure
  with:                                                       # See: https://github.com/marketplace/actions/azure-login
    creds: ${{ secrets.AZURE_CREDENTIALS }}

- uses: DFE-Digital/github-actions/keyvault-yaml-secret@master
  id: api-key-secret                                          # Set id to retrieve secret value
  with:
    keyvault: s199t01-shared-kv                               # Key vault name
    yaml_secret: infra-secrets                                # Secret in the key vault. It must contain a YAML file with the secrets
    secret: API_KEY                                           # Key in the YAML file containing the desired secret value

- name: Demo print secret
  run: echo "${{steps.api-key-secret.outputs.secret-value}}"  # Prints *** in the log as the value is masked

- uses: api-action@v1
  with:
    api-key: ${{steps.api-key-secret.outputs.secret-value}}   # The value can be used securely as input to other actions
```
