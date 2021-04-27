# Add Trello Comment

### Purpose
Given a Trello Card, this action will add a new comment to the card 

### Input Parameters
* `MESSAGE`      -  Text you want in the comment
* `CARD`         -  URL to Trello Card you wish to add the comment too
* `TRELLO-KEY`   -  Trello API KEY 
* `TRELLO-TOKEN` -  Trello Access Token 

### Security 
The TRELLO-KEY and TRELLO-TOKEN should be kept secret.
To obtain them you need to follow the [Trello instructions](https://developer.atlassian.com/cloud/trello/guides/rest-api/api-introduction/)

### Example
```       
        - name: Add Trello Comment
          uses: DFE-Digital/github-actions/AddTrelloComment@master
          with:
            MESSAGE:      "Hello World"
            CARD:         https://trello.com/c/gFLtDH7X/1-eg-book-flights            
            TRELLO-KEY:   ${{ secrets.TRELLO_KEY}}
            TRELLO-TOKEN: ${{ secrets.TRELLO_TOKEN }}
                    
```
### Pull Request
If the action is used in a GitHub pull request workflow, by passing the html_url and request body the action will create a link in the Trello card, which is a link back to the GitHub pull request.

```
      - name: Add Trello Comment
        uses: DFE-Digital/github-actions/AddTrelloComment@master
        with:
          MESSAGE:      ${{ github.event.pull_request.html_url }} 
          CARD:         ${{ github.event.pull_request.body }}           
          TRELLO-KEY:   ${{ secrets.TRELLO_KEY}}
          TRELLO-TOKEN: ${{ secrets.TRELLO_TOKEN }}
```          
