# Generate Release Information from SHA

### Purpose
During the workflow it maybe necessary to create a Release or use the information from a PR to carry out another task ( Such as update Trello ).
During the merge process you need to find out what the merging commit was via the API. 

### Input Parameters
* SHA - The commit sha you want to look for

### Outputs
* PR_NUMBER - The Pull Request number
* PR_TEXT - The text from the PR
* PR_FOUND - 0 if not found, 1 if found

### Example
```       
       - name: Generate Tag from PR Number
         id:   tag_version
         uses: DFE-Digital/github-actions/GenerateReleaseFromSHA@master
         with:
           sha: ${{github.sha}}

       - name: Create a GitHub Release
         if:   steps.tag_version.outputs.pr_found == 1
         uses: actions/create-release@v1
         env:
            GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
         with:
            tag_name: ${{ steps.tag_version.outputs.pr_number }}
            release_name: Release ${{ steps.tag_version.outputs.pr_number }}
            body: ${{ steps.tag_version.outputs.pr_text }}
            commitish: ${{github.sha}}
            prerelease: false
            draft:      false

```
