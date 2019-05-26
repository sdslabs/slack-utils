require '../loadenv.coffee'
slack = require '../api.coffee'
assert = require 'assert'

api = slack(process.env.API_TOKEN, 'https://httpbin.org/post')
it 'should post message to channel', (done)->
  api.postMessage("Hello", "general", "ghost")
  .on 'error', (err)->
    assert.fail 'TEST', 'TEST', "Request Failed"
    done()
  .on 'data', (res)->
    j = JSON.parse(res.toString())['json']
    assert.deepEqual j,
      channel: '#general',
      text:  'Hello',
      username: 'ghost',
      parse: 'full'
    done()

it 'should post a DM', (done)->
  api.sendMessage('Message', 'nemo', 'ghost')
  .on 'data', (res)->
    j = JSON.parse(res.toString())['json']
    assert.deepEqual j,
      channel: '@nemo',
      text:  'Message',
      username: 'ghost',
      parse: 'full'
    done()

it 'should parse emoji icons', (done)->
  api.postMessage('message', 'general', 'slack', ':ghost:')
  .on 'data', (res)->
    j = JSON.parse(res.toString())['json']
    assert.deepEqual j,
      channel: '#general',
      text:  'message',
      username: 'slack',
      icon_emoji: ':ghost:'
      parse: 'full'
    done()


it 'should parse url icons', (done)->
  api.postMessage('message', 'general', 'slack', 'https://i.imgur.com/WNRjxyN.jpg')
  .on 'data', (res)->
    j = JSON.parse(res.toString())['json']
    assert.deepEqual j,
      channel: '#general',
      text:  'message',
      username: 'slack',
      icon_url: 'https://i.imgur.com/WNRjxyN.jpg'
      parse: 'full'
    done()

it 'should parse invalid emoji icons', (done)->
  api.postMessage('message', 'general', 'slack', 'flags')
  .on 'data', (res)->
    j = JSON.parse(res.toString())['json']
    assert.deepEqual j,
      channel: '#general',
      text:  'message',
      username: 'slack',
      icon_emoji: ':flags:'
      parse: 'full'
    done()
