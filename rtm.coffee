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
    #ignore the presence of slackbot
    if msg.user == 'USLACKBOT'
      return
    rtm.emit msg.presence, userIdToNick(msg.user)
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

sendInitialPresenceEvent = (users) ->
  for user in users
    #again ignore the slackbot
    if user.id != 'USLACKBOT'
      rtm.emit user.presence, user.name
  return

module.exports = (API_TOKEN) ->
  #First call the rtm.start method of Slack API
  request.get {
    url: 'https://slack.com/api/rtm.start?token=' + API_TOKEN
    json: true
  }, (err, res, json) ->
    if err
      throw err
    #This is the initial response data with a lot of interesting keys
    #So we store it as well
    slackData = json
    #Emit events for initial data
    sendInitialPresenceEvent slackData.users
    #Connect the websocket
    ws = new WebSocket(json.url)
    #Sets up the callback for websocket messaging
    ws.on 'message', parseMessage
    ws.on 'open', (socket)->
      rtm.emit 'connect'
    ws.on 'error', (err)->
      rtm.emit 'error', err
    return
  #Return the eventemitter
  rtm
