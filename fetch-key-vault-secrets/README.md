# Fetch Key Vault Secrets

Fetch Secrets from the Azure Key vault taking Key Vault name and secret names as input.

## Inputs
- `keyvault`: Name of the Key Vault containing the secrets (Required)
- `secrets`: Comma separated secret names that are going to be fetched (Required)

## Outputs
- `<secretname>`: Value of the secret


## Example

```yml
  - uses: azure/login@v1
    with:
      creds: ${{ secrets.AZURE_CREDENTIALS }}

  - name: Fetch Secrets
    id: get-secret
    uses: DFE-Digital/github-actions/fetch-key-vault-secrets@master # Replace with your action repo
    with:
      keyvault: your-keyvault-name # Replace with your key vault name
      secrets: secret1,secret2,secret3 # Replace with your secret names

  - name: Use the secret value
    run: echo "SECRET 1 = ${{ steps.get-secret.outputs.secret1 }}"
    run: echo "SECRET 2 = ${{ steps.get-secret.outputs.secret2 }}"
    run: echo "SECRET 3 = ${{ steps.get-secret.outputs.secret3 }}"

```
