# Fetch Draft Release ID using Tag

### Purpose
During the workflow creating a Draft release is necessary, but there is no simple method to return it.

### Input Parameters
* TAG - Tag of the Release you require
* TOKEN - Token 

### Outputs
* ID - ID of the found release

### Example
```       
       - name: Check out the repo
         uses: actions/checkout@v2

       - name: Tests
         id: tag_version
         uses: DFE-Digital/github-actions/DraftReleaseByTag@GetIntoTeaching/DraftReleaseByTag 
         with:
           TAG: x1
           TOKEN: ${{secrets.ACTIONS_API_ACCESS_TOKEN}}
       
       - name: Print
         run:  echo ${{steps.tag_version.outputs.release_id}}

```
