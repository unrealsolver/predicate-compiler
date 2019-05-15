_ = require 'underscore'

###
<S>  ::= <pc> | <pc> <boolop> <pc>
<pc> ::= <T> <op> <T>
<op> ::= ltop | eqop | gtop
<T>  ::= String
<boolop> ::= 'andop'
###

bnf = [
  ['S', 'pc', 'boolop', 'pc']
  ['S', 'pc']
  ['pc', 'T', 'op', 'T']
  ['op', 'ltop']
  ['op', 'eqop']
  ['op', 'gtop']
  ['boolop', 'andop']
  ['T', 'String']
  ['T', 'Number']
]

getParser = ->
  stack = []

  (tokens) ->
    for t in tokens
      head = _.first stack

      mathchedRule = _.filter bnf, (rule) ->
        if stack.length == 0 then return false
        for item, idx in stack
          if item.kind != rule[idx + 1]
            return false
        return true
      
      # if matched rule
      # then reduce
      # else shift


      if mathchedRule.length == 0
        # shift
        #console.log 'stack', stack
        #console.log 'push', t
        stack.push t
      else
        # reduce
        stack.push {kind: mathchedRule[0], content: t}




module.exports = getParser
