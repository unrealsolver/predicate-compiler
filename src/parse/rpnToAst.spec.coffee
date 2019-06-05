_ = require 'underscore'
rpnToAst = require './rpnToAst.coffee'
parse = require './parser.coffee'
fsm = require 'tokenize/tokenizer.coffee'
evaluate = require 'tokenize/evaluate.coffee'
transform = require 'transformers/django.coffee'
transformMdb = require 'transformers/mdb.coffee'
compose = require 'util/compose'

deflate = (require 'tokenize/utils.coffee').deflate

reduceAst = (ast) ->
  if ast and  ast.lhs?._t and ast.rhs?._t
    reduceAst(ast.lhs) + ast._t + reduceAst(ast.rhs)
  else
    ast._t

describe 'RPN To AST/', () ->
  it 'converts to ast', () ->
    expect(
      compose(
        fsm.tokenize,
        deflate,
        evaluate,
        parse,
        rpnToAst,
        transform,
        reduceAst
      )('weight < 70 and age < 30')
    ).toBe 'weight__lt=70&age__lt=30'

  it 'converts mdb to ast', () ->
    expect(
      compose(
        fsm.tokenize,
        deflate,
        evaluate,
        parse,
        rpnToAst,
        transformMdb,
        reduceAst
      )('weight < 70 and age < 30')
    ).toBe '{lt: {weight: 70}}, {lt: {age: 30}}'
