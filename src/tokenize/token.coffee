class Token
  token: undefined
  start: undefined
  end: undefined
  token: undefined
  kind: undefined
  evaluated: undefined

OfKind = (ctor, kind) -> Object.assign(
  ctor.prototype,
  Token.prototype,
  {kind}
)

NumTok = (num) ->
  if typeof num isnt 'number'
    throw new Error "#{num} is not a Number subtype!"
  self = Object.create NumTok.prototype
  self.token = String num
  self.evaluated = num
  self

NumTok.prototype = OfKind NumTok, 'Number'


StrTok = (str) ->
  if typeof str isnt 'string'
    throw new Error "#{str} is not a String subtype!"
  self = Object.create StrTok.prototype
  self.token = str
  self.evaluated = str
  self

StrTok.prototype = OfKind StrTok, 'String'

mapOpToKind =
  '<': 'ltop'
  '<=': 'lteqop'
  'and': 'andop'
  'or': 'orop'
  'xor': 'xorop'

OpTok = (op) ->
  opkind = mapOpToKind[op]
  unless opkind
    throw new Error "Invalid operator #{op}!"
  self = Object.create OpTok.prototype
  self.token = op
  self.kind = opkind
  self

OpTok.prototype = OfKind OpTok

LtTok = OpTok '<'
AndTok = OpTok 'and'
OrTok = OpTok 'or'

export {NumTok, StrTok, OpTok, LtTok, AndTok, OrTok}
