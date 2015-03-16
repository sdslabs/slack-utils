#slack-utils [![Build Status](https://travis-ci.org/captn3m0/slack-utils.svg?branch=master)](https://travis-ci.org/captn3m0/slack-utils)

This is a collection of various slack-api related scripts that I've written. Published as an npm module.

Development is done in coffeescript, but that is not a dependency for usage.

#Installation

    npm install --save slack-utils

[![NPM](https://nodei.co/npm/slack-utils.png?downloads=true&downloadRank=true&stars=true)](https://nodei.co/npm/slack-utils/)

#Usage

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
  * `active`: When a user's presence changes to active
  * `away`: When a user's presence changes to away
  * `*`: Emitted for all slack-events (not for 3 low-level events: connect, ready, and error)

#Differences

This is not a one-to-one mapping for the various slack APIs. This is done for a reason:

* Simplicity. You should be able to use various APIs without having to worry about things like userid translation
* Other 1-1 APIs already exist
* We add extra events and methods to simplify usage. For eg, we include a `sendMessage` and a `postMessage` event to send a direct message or a public message. This is hidden inside the incoming webhook docs, but we surface it as 2 method calls.
* The aim is to make your code more terse and readable.

#Development

- Code is written in coffeescript
- Editorconfig is used for indentation guidelines
- Coffeescript is pushed to github
- Testing is done via mocha, and travis
- `npm test` works
- Only javascript is pushed to npm
- Coffeescript is a development dependency, so its not installed in production
- `ws` and `request` are used for websocket and http API usage

#Help Needed

* Since I am pretty used to the slack API by now, I am very much comfortable writing this.
* I'd love if people used this for their services.
* Please file an issue if you have a usecase not covered by this.
* I am not used to writing javascript APIs, so I'd love to hear thoughts on how this can be improved
* Documentation. I'd get around to it soon, but I'd love a helping hand. Will probably use docco.

#License

Licensed under [MIT](http://nemo.mit-license.org/)
