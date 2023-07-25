## Fetch Key Vault Secret
This action uses the az CLI to retrieve a value of a secret that resides in the Azure Key Vault
[Usage](/.github/workflows/test-fetch-key-vault-secret.yml)
### Usage
```yml
    - uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Fetch Secret Value
        id: get-secret
        uses: DFE-Digital/github-actions/fetch-key-vault-secret@master # Replace with your action repo
        with:
          KEY_VAULT: your-keyvault-name # Replace with your key vault name
          SECRET: your-secret-name # Replace with your secret name

      - name: Use the secret value
        run: echo "${{ steps.get-secret.outputs.secret }}"
```
