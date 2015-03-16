#slack-utils [![Build Status](https://travis-ci.org/captn3m0/slack-utils.svg?branch=master)](https://travis-ci.org/captn3m0/slack-utils)

This is a collection of various slack-api related scripts that I've written. Published as an npm module.

Development is done in coffeescript, but that is not a dependency for usage.

#Usage Examples

Currently, utils consists of 2 modules: `api` and `rtm`. All possible methods are demonstrated below:

```js

// Initialize api
api = require('slack-utils/api')('SLACK_API_TOKEN', 'INCOMING_HOOK_URL')

// channel is the channel name (such as general)
// nick is the username of the user to send the message to
// username is the username used by the webhook
api.postMessage('message', 'channel', 'username')
api.sendMessage('message', 'nick', 'username')

// Initialize rtm
// You can get an API_TOKEN from https://api.slack.com/web for your personal account
// Or by creating a bot user at https://my.slack.com/services/new/bot
rtm = require('../rtm.coffee')(API_TOKEN);

rtm.on('event', function(msg){
  // Do whatever you want with the data
  // msg.type will be same as event name
})
```

* A list of events emitted can be found at https://api.slack.com/rtm
* Few extra events are emitted as well:
  * `connect`: When the websocket connects to the RTM server
  * `ready`: When Slack responds to our RTM connection
  * `error`: In case of an error in the websocket connection
  * `*`: Emitted for all slack-events (not for above 3 special events)
