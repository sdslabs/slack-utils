slack = require '../api.coffee'
assert = require 'assert'

api = slack(process.env.API_TOKEN, 'http://httpbin.org/post')

it 'should parse message of type http://x.y.z|x.y.z', ()->
  res = api.parseMessage('https://google.com|google.com')
  assert res == 'https://google.com'
