# Fetch Draft Release ID using Tag

### Purpose
During the workflow creating a Draft release is necessary, but there is no simple method to return it.
Since we are calling the API and we are returning information that can be used later, we might as well 
make it available.

### Input Parameters
* TAG - Tag of the Release you require
* TOKEN - GITHUB Token 

### Outputs
* release_id - ID of the found release or NULL if not found
* release_name - Name of the release
* release_body - Body text of the release
* release_sha  - Target Commit SHA of the Release
* found - 1 or 0 depending on whether the release was found ( depreciated )

### Example
```       
       - name: Check out the repo
         uses: actions/checkout@v2

       - name: Tests
         id: tag_version
         uses: DFE-Digital/github-actions/DraftReleaseByTag@master
         with:
           TAG: x1
           TOKEN: ${{secrets.ACTIONS_API_ACCESS_TOKEN}}
       
       - name: Print
         if:   steps.tag_version.outputs.release_id 
         run:  |
               echo ID ${{steps.tag_version.outputs.release_id}}
               echo NAME ${{steps.tag_version.outputs.release_name}}
               echo BODY ${{steps.tag_version.outputs.release_body}}

```
