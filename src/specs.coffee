# Unit Tests
import './tokenize/tokenizer.spec'
import './parse/parser.spec'
import './parse/rpnToAst.spec'
import './util/compose.spec'

# Full featur / E2E testing
import _ from 'underscore'
import { rpnToAst } from 'parse/rpnToAst'
import parse from 'parse/parser'
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

describe 'Complete E2E', () ->
  it 'Django', () ->
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

  it 'MongoDB', () ->
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
