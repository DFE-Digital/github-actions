# Copy PR to Release

### Purpose
Copy the PR body to the Release body

### Input Parameters
* `PR_NUMBER`  -  Pull Request number from which you want to extract the body from
* `RELEASE_ID` -  Release ID which you want to update
* `TOKEN`      -  GITHUB TOKEN

### Example
```       
  - name: Check out the repo
    uses: actions/checkout@v2

  - name: Copy
    uses: DFE-Digital/github-actions/CopyPRtoRelease@master
    with:
         PR_NUMBER: 10
         RELEASE_ID: 35157528
         TOKEN: ${{secrets.GITHUB_TOKEN}}
                    
```
