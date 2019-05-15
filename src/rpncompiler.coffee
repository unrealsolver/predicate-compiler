_ = require 'underscore'

# Backus-Naur form
# E   ::= E&E | LHS=RHS
# RHS ::= Term
# LHS ::= I | I__op
# op  ::= lt | gt | eq

nonTerminals = ['E', 'LHS', 'RHS', 'op']
terminals = ['=', '&', '__', 'I', 'Term', 'lt', 'gt', 'eq']
rules = [
  ['E', 'E', '&', 'E'],
  ['E', 'LHS', '=', 'RHS'],
  ['RHS', 'Term'],
  ['LHS', 'Term'],
  ['LHS', 'Term', '__', 'op'],
  ['op', 'eq'],
  ['op', 'lt'],
  ['op', 'gt'],
]

IG = [
  ['E', 'E', 'E', 'op'],
  ['E', 'T']
  ['op', 'lt']
  ['op', '&']
]

OG = [
  ['E', 'E', 'E', '&'],
  ['E', 'LHS', 'RHS', '='],
  ['RHS', 'T'],
  ['LHS', 'T'],
  ['LHS', 'T', 'op', '__'],
  ['op', 'lt'],
]

MAPPING = [
  # IG   OG
  ['E', 'E'],
  ['T', 'T'],
  ['lt', 'lt'],
  ['&', '&'],
]

lookup = (G, token) ->
  rule = _.find G, (items) -> token in items

  if rule.length == 2
    # substitute
    _.find G, (items) -> rule[0] in items
  else
    rule

translate = (tok) ->
  switch tok
    when '<' then 'lt'
    when '>' then 'gt'
    when 'and' then '&'

rpncompile = (input) ->
  input = input.reverse()
  stack = []

  while input.length
    tok = input.pop()

    if tok.kind in ['Number', 'String']
      stack.push tok
    else
      ## Django
      #if tok.token in ['<', '>']
      #  rv = stack.pop()
      #  lv = stack.pop()
      #  exp = "#{lv.token}__#{translate(tok.token)}=#{rv.token}"
      #  stack.push exp
      #else if tok.token == 'and'
      #  rv = stack.pop()
      #  lv = stack.pop()
      #  exp = "#{lv}#{translate(tok.token)}#{rv}"
      #  stack.push exp
      ## MDB
      if tok.token in ['<', '>']
        rv = stack.pop()
        lv = stack.pop()
        exp = "#{lv.token}: {$#{translate(tok.token)}: '#{rv.token}'}"
        stack.push exp
      else if tok.token == 'and'
        rv = stack.pop()
        lv = stack.pop()
        exp = "#{lv}, #{rv}"
        stack.push exp

###
-- 0 --
rpn: a b <
st:
-- 1 --
rpn: b <
st: a
-- 2 --
rpn: <
st: b a
-- 3 --
rpn: op(lt)
st: b a
-- 4 --
rpn: 
st:
###

nonMappapble = ['__']

whatis = (token) ->
  switch token.kind
    when 'String', 'Number' then 'Term'
    when 'ltop' then 'lt'
    when 'gtop' then 'gt'
    when 'eqop' then 'eq'
    when 'and' then '&'


translate1 = (token) ->
  switch token.kind
    when 'String', 'Number' then token.token
    when 'ltop' then 'lt'
    when 'gtop' then 'gt'
    when 'eqop' then 'eq'
    when 'and' then '&'

class Token
  constructor: (@kind ,@content) ->
  toString: -> @content


rpncompile1 = (rpn) ->
  stack = _.map rpn.reverse(), (d) -> new Token whatis(d), translate d
  depth = 0

  compile = (token) ->
    matchedRules = _.filter rules, (rule) ->
      rule[0] != token.kind and token.kind in rule


    rule = matchedRules[0]
    if rule.length == 2
      return new Token rule[0], token.content
    if rule.length == 4
      parts = rule[1..]

      if parts[0] == token.kind
        addition = stack.pop()
        #if addition.kind != parts[2]
        #  throw new Error "Syntax error: expected #{parts[2]} but #{addition.kind} received"
        return new Token rule[0], token.content + parts[1] + compile(addition)

      if parts[2] == token.kind
        #tmp = stack.pop()
        addition = stack.pop()
        #stack.push tmp
        if addition.kind != parts[0]
          throw new Error "Syntax error: expected #{parts[0]} but #{addition.kind} received"
        return new Token rule[0], compile(addition) + parts[1] + token.content

      if parts[1] == token.kind
        rval = stack.pop()
        lval = stack.pop()
        #if addition.kind != parts[0]
        #  throw new Error "Syntax error: expected #{parts[0]} but #{addition.kind} received"
        return new Token rule[0], compile(lval) + token.content + compile(rval)

  while stack.length
    if depth++ > 10 then throw new Error 'Max depth reached!'
    tok = stack.pop()
    stack.push compile tok

module.exports = rpncompile
