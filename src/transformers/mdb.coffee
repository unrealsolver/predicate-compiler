translate = (node) ->
  tok = node.op
  if tok.kind in ['Number']
    [false, tok.token]
  if tok.kind in ['String']
    [false, "\"#{tok.token}\""]
  else if tok.kind is 'and'
    [true, ', ']
  else if tok.kind is 'ltop'
    [false, "{lt: {#{node.lhs.token}: #{node.rhs.token}}}"]

transform = (ast) ->
  [godown, tok] = translate ast

  ast._t = tok
  if godown
    transform(ast.lhs)
    transform(ast.rhs)

  ast

module.exports = transform
