# Set Up Environment

### Purpose
Sometimes we will want to have common environment variables across a number of
workflows, these are not secret, but can handle things like colours and titles.
To maintain consistancy and allow commonality of code it is desirable to have one 
location for these variables.

### Input Parameters
* FILE -  Name of Environment File

### Example
```       
       - name: Check out the repo
         uses: actions/checkout@v2

```
