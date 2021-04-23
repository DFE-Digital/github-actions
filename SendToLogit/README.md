# Send a Log entry to Logit.io

### Purpose
There is a requirement to push certain events into logit.io (ELK) so that it can be presented on a dashboard in Grafana. 

This routine has been made generic, so that it can be reused if necessary and additional data points can be simply added.

The log is structured as json so it will be indexed efficiently in Elasticsearch and allows queries and visualisations in Kibana

### Input Parameters
* LOGIT-API-KEY - API Key for Logit
* JSON          - JSON Payload
* logtype       - Defaults to custom

You can find instructions on how to obtain the LOGIT-API-KEY via [Logits Documentation](https://logit.io/sources/configure/json)

### Example
```       

name:  Test
on:
  workflow_dispatch:

jobs:
  LOGIT:
    runs-on: ubuntu-latest
    steps:
    
       - name: Tests
         uses: DFE-Digital/github-actions/SendToLogit@master
         with:
           LOGIT-API-KEY: ${{secrets.LOGIT_API_KEY}}
           JSON:   |
                   '{"Application":"Get-into-Teaching-API", 
                     "Status":"Success",
                     "Action":"Deploy",
                     "Environment": "Production",
                     "Version": "1" }'

```

## LOGIT
### Logstash Filters
The data will be pushed into Logit.io as type *custom*, unless you override it on the action, therefore to index properly you need to include the following in your logstash filters

```
    if [type] == "custom" {
    	json {
          source => "message"
          target => "github"
    	}
        
	}
```

This will extract your data from the message and prefix it with github. for example, Application will become github.application. By doing this you ensure that you are keeping the data seperatly indexed from other data in the system.

### Reindex
Once you have loaded your first full sets of data it is important that you reindex the data to enable kibana access to it. This can be carried out using the GUI, 

