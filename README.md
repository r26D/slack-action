# Slack Action

This action prints "Hello World" to the log or "Hello" + the name of a person to greet. To learn how this action was built, see "[Creating a Docker container action](https://help.github.com/en/articles/creating-a-docker-container-action)" in the GitHub Help documentation.

## ENV

### SLACK_WEBHOOK_URL

You must set an env with the url of the slack web hook to use for the action.

## Inputs

### `headline`

**Required** This is the main headline of the mssage 
### `body`

**Required** (If you are going to do an image) This is the text underneath the headline
### `imageUrl`
This is a url for the image to be used on the specific message. 

Emojis can be done inline as text  :smile:

## Example usage

```yaml
uses: r26d/slack-action@master
env:
  SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL}}
with:
  headline: "My First Headline"
  body: "I hope this makes things easier"
  imageUrl: "https://images.unsplash.com/photo-1517594422361-5eeb8ae275a9?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=60"

```
