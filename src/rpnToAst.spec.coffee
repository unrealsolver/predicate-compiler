_ = require 'underscore'
rpnToAst = require './rpntoast.coffee'
getParser = require './parser.coffee'
fsm = require './tokenizer.coffee'
transform = require './transformers/django.coffee'
transformMdb = require './transformers/mdb.coffee'

deflate = (gen) ->
  for val from gen
    val

reduceAst = (ast) ->
  if ast and  ast.lhs?._t and ast.rhs?._t
    reduceAst(ast.lhs) + ast._t + reduceAst(ast.rhs)
  else
    ast._t

compose = (...fns) ->
  _.compose.apply _, fns.reverse()

describe 'RPN To AST/', () ->
  it 'converts to ast', () ->
    parse = getParser()

    #reduceAst transform rpnToAst parse deflate fsm.tokenize 'weight < 70 and age < 30'
    expect(
      compose(
        fsm.tokenize,
        deflate,
        getParser(),
        rpnToAst,
        transform,
        reduceAst
      )('weight < 70 and age < 30')
    ).toBe 'weight__lt=70&age__lt=30'

  it 'converts mdb to ast', () ->
    parse = getParser()

    #reduceAst transform rpnToAst parse deflate fsm.tokenize 'weight < 70 and age < 30'
    expect(
      compose(
        fsm.tokenize,
        deflate,
        getParser(),
        rpnToAst,
        transformMdb,
        reduceAst
      )('weight < 70 and age < 30')
    ).toBe '{lt: {weight: 70}}, {lt: {age: 30}}'
