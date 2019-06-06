import _ from 'underscore'
import rpnToAst from './rpnToAst'
import parse from './parser'
import fsm from 'tokenize/tokenizer'
import evaluate from 'tokenize/evaluate'
import transform from 'transformers/django'
import transformMdb from 'transformers/mdb'
import compose from 'util/compose'
import { deflate } from 'tokenize/utils'

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
