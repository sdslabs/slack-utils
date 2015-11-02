require '../loadenv.coffee'
slack = require '../api.coffee'
assert = require 'assert'

api = slack(process.env.API_TOKEN)

it 'should return user info by name', (done)->
  this.timeout = 6000
  setTimeout ()->
    info = api.userInfoByName('nemo')
    assert info.name == 'nemo'
    done()
  , 4000

it 'should return user info by id', ()->
  info = api.userInfoById('U02K78YST')
  assert info.name == 'mako'
