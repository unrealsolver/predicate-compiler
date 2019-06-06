translate = (node) ->
  tok = node.op
  if tok.kind in ['String', 'Number']
    [false, tok.token]
  else if tok.kind is 'andop'
    [true, '&']
  else if tok.kind is 'ltop'
    [false, "#{node.lhs.token}__lt=#{node.rhs.token}"]

transform = (ast) ->
  [godown, tok] = translate ast

  ast._t = tok
  if godown
    transform(ast.lhs)
    transform(ast.rhs)

  ast

export default transform
