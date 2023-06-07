# Set Azure Resource Manager environment variables

Sets the environment variables suitable for running Terraform. It also masks the environment variables.

## Inputs

- `azure-credentials` - A JSON string containing service principle credentials.

## Example

```yaml
- name: Set ARM environment variables
  uses: DFE-Digital/github-actions/set-arm-environment-variables@master
  with:
    azure-credentials: ${{ secrets.AZURE_CREDENTIALS }}
```
