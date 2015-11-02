request = require('request')

listToHash = (list, keyName, innerKey)->
  list = list[keyName]
  hash = {}
  for item in list
    if innerKey?
      hash[item.id] = item[innerKey]
    else
      hash[item.id] = item
  hash

data = {}

getUsers = (token)->
  request.get {url: "https://slack.com/api/users.list?token=#{token}", json: true}, (err, res, users)->
    throw err if err
    data['users.simple'] = listToHash users, "members", "name"
    data['users'] = listToHash users, "members"

getChannels = (token)->
  request.get {url: "https://slack.com/api/channels.list?token=#{token}", json: true}, (err, res, channels)->
    throw err if err
    data['channels.simple'] = listToHash channels, "channels", "name"
    data['channels'] = listToHash channels, "channels"

module.exports = (API_TOKEN, HOOK_URL)->

  if API_TOKEN?
    getUsers(API_TOKEN)
    getChannels(API_TOKEN)

  postMessage: (message, channel, nick, icon, attachments)->
    messageData =
      text: message
      parse: "full"
      attachments: attachments

    if icon? and (icon[0..7] == 'https://' or icon[0..6] == 'http://')
      messageData.icon_url = icon
    # If icon is present and is not an emoji
    else if icon? and not icon.match /^\:\w*\:$/
      messageData.icon_emoji = ":#{icon}:"
    # If icon is present and is an emoji
    else if icon? and icon.match /^\:\w*\:$/
      messageData.icon_emoji = icon
    if channel?
      messageData.channel = "##{channel}"
    if nick?
      messageData.username = nick

    request.post
      url: HOOK_URL
      json: messageData

  sendMessage: (message, to, as)->
    request.post
      url: HOOK_URL
      json:
        text:     message
        username: as
        parse:    "full"
        channel: "@#{to}"

  # exporting this to test the method
  listToHash: listToHash
  parseMessage: (message)->
    message
      .replace("<!channel>", "@channel")
      .replace("<!group>", "@group")
      .replace("<!everyone>", "@everyone")
      .replace /<#(C\w*)>/g, (match, channelId)->
        "##{data['channels.simple'][channelId]}"
      .replace /<@(U\w*)>/g, (match, userId)->
        "@#{data['users.simple'][userId]}"
      .replace /<(\S*)>/g, (match, link)->
        link
      .replace /&amp;/g, "&"
      .replace /&lt;/g, "<"
      .replace /&gt;/g, ">"

  userInfoById: (search_id)->
    for id, info of data['users']
      return info if search_id == id

  userInfoByName: (username)->
    for id, info of data['users']
      return info if info['name'] == username
