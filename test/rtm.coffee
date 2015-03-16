require '../loadenv.coffee'
rtm = require('../rtm.coffee')(process.env.API_TOKEN)
assert = require 'assert'

expected_events = [
  'connect', 'ready', '*'
]

removeDuplicates = (ar) ->
  if ar.length == 0
    return []
  res = {}
  res[ar[key]] = ar[key] for key in [0..ar.length-1]
  value for key, value of res

emitted_events = []

for e in expected_events
  do (e) ->
    rtm.on e, (msg)->
      emitted_events.push e

it 'should expect all events to be emitted', (done)->
  setTimeout ( ->
    # Check if all events have been emitted
    assert.deepEqual expected_events, removeDuplicates(emitted_events)
    done()
  ), 5000
