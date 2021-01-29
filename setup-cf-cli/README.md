## Setup Cloud Foundry CLI
Installs the Cloud Foundry CLI and logs the specified user into `CF_SPACE_NAME`.
### Usage
```yml
 - uses: DFE-Digital/github-actions/setup-cf-cli@master
   with:
     CF_USERNAME: ${{ secrets.CF_USERNAME }}
     CF_PASSWORD: ${{ secrets.CF_PASSWORD }}
     CF_SPACE_NAME: bat-qa # required
     # Optional inputs
     CF_CLI_VERSION: v7 # default v7, allowed values: v6 or v7
     CF_ORG_NAME: dfe # default
     CF_API_URL:  https://api.london.cloud.service.gov.uk # default
     INSTALL_CONDUIT: true # default: false
```
