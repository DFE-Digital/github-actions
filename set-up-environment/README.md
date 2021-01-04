# Setup Environment Variables

### Purpose
Sometimes we will want to have common environment variables across a number of
workflows, these are not secret, but can handle things like colours and titles.
To maintain consistancy and allow commonality of code it is desirable to have one 
location for these variables.

### Input Parameters
* `var_file` -  Name of Environment File optional but defaults to .github/common_environment.yml

### Caution
> The environment variables are only set for the specific JOB and will need to be set on each job
> that uses them

### Example
[See Example Workflow](/.github/workflows/test-setup-environment-variables.yml)
```       
  - name: Check out the repo
    uses: actions/checkout@v2

  - name: set-up-environment
    uses: DFE-Digital/github-actions/set-up-environment@master             
                    
  - name: Print
    run:  |
          echo "URL                   = ${{env.SLACK_ICON}}"
          echo "APPLICATION           = ${{env.APPLICATION}}"
          echo "DOCKERHUB_REPOSITORY  = ${{env.DOCKERHUB_REPOSITORY}}"
          echo "DOMAIN                = ${{env.DOMAIN}}"
          echo "PAAS_APPLICATION_NAME = ${{env.PAAS_APPLICATION_NAME}}"
          echo "SLACK_FAILURE         = ${{env.SLACK_FAILURE}}"
          echo "SLACK_SUCCESS         = ${{env.SLACK_SUCCESS}}"
```
