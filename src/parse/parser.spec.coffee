_ = require 'underscore'
fsm = require 'tokenize/tokenizer.coffee'
evaluate = require 'tokenize/evaluate.coffee'
getParser = require './parser.coffee'
getAstParser = require './astparser.coffee'
deflate = (require 'tokenize/utils.coffee').deflate


describe 'Parser/', ->
  it 'parses', ->
    parse = getParser()
    rpn = parse evaluate deflate fsm.tokenize '10<20'
    expect(rpn[0].token).toBe '10'
    expect(rpn[1].token).toBe '20'
    expect(rpn[2].token).toBe '<'

  it 'parses1', ->
    parse = getParser()
    rpn = parse evaluate deflate fsm.tokenize 'value<20'
    expect(rpn[0].token).toBe 'value'
    expect(rpn[1].token).toBe '20'
    expect(rpn[2].token).toBe '<'

  it 'parses2', ->
    parse = getParser()
    tokens = evaluate deflate fsm.tokenize 'a < 1 and b < 2'
    rpn = parse tokens
    expect(_.map rpn, (d) -> d.token).toEqual [
      'a', '1', '<', 'b', '2', '<', 'and'
    ]

  it 'compiles', ->
    parse = getParser()

  it 'astpaseses', ->
    parse = getAstParser()
    rpn = parse evaluate deflate fsm.tokenize 'value<20'