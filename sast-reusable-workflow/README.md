# SAST Reusable Workflow

Reusable workflows must be kept in the [.github/workflows](../.github/workflows) directory, find the SAST reusable workflow at the link below: 

* [CodeQL SAST reusable workflow](../.github/workflows/reusable-workflow-sast.yml)

The workflow also utilises [GitHub Policy as Code](https://github.com/advanced-security/policy-as-code/) for CodeQL scans, to allow teams to break builds where security issues are over SLA, to highlight where malicious typosquatting packages have been accidentally included in the build, and to raise Dependabot, CodeQL, Secret Scanning and Licensing issues in the pipeline. 

Policy information can be found at [.github/policy-as-code](../.github/policy-as-code):
* [The policy yaml file, showing SLAs for issues](../.github/policy-as-code/ghas-policy.yml)
* [The typosquatting list, to ensure known malicious typosquat packages aren't included in builds](../.github/policy-as-code/typosquatting.txt)

> [!WARNING]
> DfE do not currently pay for GitHub Advanced Security, so this workflow runs CodeQL for SAST scans if the repository is public (as it's free for public repos). Otherwise, we will utilise semgrep open source SAST. The policy as code feature will also only work for CodeQL scans.

### Purpose
1. Provide DfE services with an easy to use workflow for static code analysis, to improve the security and quality of code.
2. To provide the ability to (optionally) stop deployments if security issues are found to be over SLA and to highlight issues in the pipeline found for CodeQL, Dependabot and GitHub Secret Scanning (only works for public repos).

### Input Parameters

* `language` - The language used in the repository you're scanning. C#/.NET = 'csharp', JavaScript/TypeScript = 'javascript', ruby = 'ruby'
* `dotnet_version` - dotnet version for building the app (if a .NET app)
* `config_file` - path to a config file for codeql to read (if you have one)
* `nuget-source-url` - The url to the nuget source used by the project e.g. https://nuget.pkg.github.com/DfE-Digital/index.json
* `dotnet_project_locations` - csproj file locations for build
* `dotnet_build_params` - dotnet build params
* `dotnet_clean` - run dotnet clean
* `dotnet_tool_restore` - Turn on tool restore where required
* `queries` - The queries CodeQL should run against the code. Options - security, security-and-quality, security-extended
* `debug` - Set codeql debug true to help with debugging codeql specific issues
* `ref` - The fully-formed ref of the branch or tag that triggered the workflow run. If you're using a pull_request type closed, you may need to set this. Otherwise the default from github will be used.
* `sha` - The commit SHA that triggered the workflow.
* `policy_action` - The action to take if policy-as-code checks fail thresholds options: ['break', 'continue']
* `force_semgrep` - Force this workflow to use semgrep instead of codeql - codeql is the default option unless the repository is private, otherwise it falls back to semgrep.

### Secrets

* `NUGET_AUTH_TOKEN` - This is the token required for Nuget to authenticate to the packages repository via the nuget-source-url (only required if you're using a private nuget repository).
* `CODEQL_AUTHENTICATION_PRIVATE_KEY` - Private key used to authenticate as GitHub App.
* `CODEQL_APP_ID` - The app ID of the GitHub App used to authenticate with GHAS compliance.

> [!IMPORTANT]
> In order for the compliance job to run, you must provide the `CODEQL_AUTHENTICATION_PRIVATE_KEY` and `CODEQL_APP_ID` secrets, they have been made available as organisation secrets, so you simply need to reference it in your workflow job.
        
### Examples
#### .NET
```
jobs:
  run-codeql:
    uses: DFE-Digital/github-actions/.github/workflows/reusable-workflow-sast.yml@master
    with:
      language: 'csharp' 
      dotnet_project_locations: '["./"]' 
      dotnet_version: '6.0.*' 
      policy_action: 'break'
      nuget-source-url: 'https://nuget.pkg.github.com/DfE-Digital/index.json' # only required if you're using a private nuget source
    secrets:
      CODEQL_AUTHENTICATION_PRIVATE_KEY: ${{ secrets.CODEQL_AUTHENTICATION_PRIVATE_KEY }} 
      CODEQL_APP_ID: ${{ secrets.CODEQL_APP_ID }}
      NUGET_AUTH_TOKEN: ${{ secrets.NUGET_AUTH_TOKEN }} # if private


```

#### Ruby
```
jobs:
  run-codeql:
    uses: DFE-Digital/github-actions/.github/workflows/reusable-workflow-sast.yml@master
    with:
      language: 'ruby' 
      policy_action: 'break'
      queries: 'security-extended'
    secrets:
      CODEQL_AUTHENTICATION_PRIVATE_KEY: ${{ secrets.CODEQL_AUTHENTICATION_PRIVATE_KEY }} 

```
