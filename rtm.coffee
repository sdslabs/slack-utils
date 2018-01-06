request = require('request')
WebSocket = require('ws')
EventEmitter = require('events').EventEmitter
rtm = new EventEmitter
slackData = {}

#eventemitter FTW!
#parses an RTM event

parseMessage = (msg) ->
  msg = JSON.parse(msg)
  #we are only interested in presence change
  if msg.type == 'presence_change'
    sendPresenceEvent msg
  else if msg.type == 'hello'
    rtm.emit 'ready'
  else
    rtm.emit msg.type, msg
  rtm.emit '*', msg
  return

#translates a slack unique userid to readable username

userIdToNick = (userid) ->
  users = slackData.users
  for user in users
    if user.id == userid
      return user.name
  'unknown'

#throw the initial data to the database
#via the events

sendPresenceEvent = (msg) ->
  for user in msg.users
    #ignore the slackbot
    if user.id != 'USLACKBOT'
      rtm.emit msg.presence, userIdToNick user
  return

getPresenceSubscriptionJson = (users) ->
  JSON.stringify
    type: "presence_sub"
    ids: users.map (user) -> user.id

module.exports = (API_TOKEN) ->
  #First call the rtm.start method of Slack API
  request.get
    url: 'https://slack.com/api/rtm.start?batch_presence_aware=1&token=' + API_TOKEN
    json: true
  , (err, res, json) ->
    if err
      throw err
    #This is the initial response data with a lot of interesting keys
    #So we store it as well
    slackData = json
    #Connect the websocket
    ws = new WebSocket(json.url)
    #Sets up the callback for websocket messaging
    ws.on 'message', parseMessage
    ws.on 'open', (socket)->
      rtm.emit 'connect'
    ws.on 'error', (err)->
      rtm.emit 'error', err
    rtm.on 'ready', () ->
      ws.send getPresenceSubscriptionJson slackData.users
    return
  #Return the eventemitter
  rtm
