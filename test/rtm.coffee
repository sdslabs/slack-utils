require '../loadenv.coffee'
rtm = require('../rtm.coffee')(process.env.API_TOKEN)
equal = require 'deep-equal'
assert = require 'assert'

expected_events = [
  'connect', 'ready', '*'
]

emitted_events = []

wait_for_events = (cb)->
  cb_called = false
  for e in expected_events
    do (e) ->
      rtm.on e, (msg)->
        emitted_events.push e unless e in emitted_events
        if not cb_called and equal expected_events, emitted_events
          cb()
          cb_called = true

it 'should expect all events to be emitted', (done)->
  wait_for_events ()->
    done()
