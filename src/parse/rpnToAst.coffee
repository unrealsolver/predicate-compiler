class Node
  lhs: undefined
  rhs: undefined
  op: undefined

  constructor: (@op, @lhs, @rhs) ->


rpnToAst = (rpn) ->
  stack = []

  for d in rpn
    if d.kind in ['Number', 'String']
      stack.push d
    else
      rhs = stack.pop()
      lhs = stack.pop()
      stack.push new Node d, lhs, rhs

  return stack[0]

export {Node, rpnToAst}
