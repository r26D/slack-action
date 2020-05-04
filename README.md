# Slack Action

This action relies on having the Incoming WebHook app (https://slack.com/apps/A0F7XDUAZ-incoming-webhooks) installed on your slack.
This allows you a lot more customizing.


## ENV

### SLACK_WEBHOOK_URL

You must set an env with the url of the slack web hook to use for the action.

## Inputs
### `channel`
**Required** This is the channel the message will be sent to.

### `username`
Optional - this is the username used for the message

### `iconEmoji`
Optional - this icon will be used in the post

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
  channel: "#general"
  username: me
  icon_emoji: ":ghost:"
  headline: "My First Headline"
  body: "I hope this makes things easier"
  imageUrl: "https://images.unsplash.com/photo-1517594422361-5eeb8ae275a9?ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=60"

```
