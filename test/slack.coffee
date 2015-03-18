require '../loadenv.coffee'
slack = require "../api.coffee"
assert = require "assert"

expected_without_inner_key =
  "1":
    id: "1",
    name: "one"
  "2":
    id: "2",
    name: "two"

expected_with_inner_key =
  "1": "one"
  "2": "two"

list =
  "list": [
      id: "1",
      name: "one"
    ,
      id: "2",
      name: "two"
  ]

it 'should parse lists with inner key', ()->
  assert.deepEqual expected_with_inner_key, slack().listToHash list , "list", "name"

it 'should parse lists without inner key', ()->
  assert.deepEqual expected_without_inner_key, slack().listToHash list , "list"

