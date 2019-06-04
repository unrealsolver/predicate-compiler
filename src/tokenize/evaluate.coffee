evaluate = (tokens) ->
  tokens.map (tok) ->
    if tok.kind is 'Number'
      tok.evaluated = Number(tok.token)
    else if tok.kind is 'String'
      tokLower = tok.token.toLowerCase()
      if tokLower in ['and', 'or', 'xor']
        tok.kind = tokLower + 'op'
    tok

module.exports = evaluate
