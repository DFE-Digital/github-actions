myArray=("SLACK-WEBHOOK")


for SECRET_NAME in "${myArray[@]}"; do
          SECRET_VALUE=$(az keyvault secret show --name "$SECRET_NAME" --vault-name "s189t01-gitapi-dv-inf-kv" --query "value" -o tsv)
          echo "$SECRET_NAME = $SECRET_VALUE"
          # echo "::add-mask::$SECRET_VALUE"

        #   echo "$SECRET_NAME=$SECRET_VALUE" >> "$GITHUB_OUTPUT"

        done
