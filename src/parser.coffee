# The parser implements  Dijkstra Shunting Yard algorithm

_ = require 'underscore'
UNARY = Symbol 'Unary operator'

syntax =
  'or': -1
  'and': -1
  '<': 0
  '<=': 0
  '+': 1
  '*': 2
  '!': UNARY
  not: UNARY

getParser = ->
  stack = []
  rpn = []

  (tokens) ->
    for t in tokens
      # Inline eval
      if t.kind == 'String' and t.token == 'and'
        t.kind = 'and'

      if t.kind in ['Number', 'String']
        rpn.push t
      else
        head = _.last stack
        if head and syntax[t.token] <= syntax[head.token]
          rpn = rpn.concat stack.reverse()
          stack = [t]
        else
          stack.push t

    return rpn.concat stack.reverse()

module.exports = getParser
