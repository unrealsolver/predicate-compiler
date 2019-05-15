fsm = require './tokenizer.coffee'
_ = require 'underscore'

deflate = (gen) ->
  for val from gen
    val

checkSingleToken = (kind, token) ->
  tokens = deflate fsm.tokenize token
  expect(tokens.length).toBe 1
  expect(tokens).toEqual [
    start: 0
    end: token.length - 1
    kind: kind
    token: token
  ]

checkForbidSingleToken = (token) ->
  expect(() ->
    tokens = deflate fsm.tokenize token
    console.error tokens
    console.error "Token '#{token}' should not be allowed!"
  ).toThrow()

describe 'Tokenizer/', () ->
  describe 'Numbers/', () ->
    check = checkSingleToken.bind(null, 'Number')
    checkAll = (...tokens) -> _.each tokens, check
    checkForbidAll = (...tokens) -> _.each tokens, checkForbidSingleToken

    it 'allows integer numbers', () ->
      checkAll '0', '1', '001', '1234', '1234567890'

    it 'allows float numbers', () ->
      checkAll '0.0', '1.0', '000.01', '.1', '123456.123456'

    it 'allows scientific numbers', () ->
      checkAll '0e+0', '0e0', '0e-0', '42e+42', '05e-05', '0.5e+1', '.5e-1'

    it 'forbids invalid numbers', () ->
      checkForbidAll(
        'e+0', 'e-0', '1+e1', '1-e1', '1.2.3', '1..2', '1.', '1e+1.5', '1+e.5'
      )

  describe 'Operators/', () ->
    it 'allows simple operators', ->
      checkSingleToken 'ltop', '<'

    it 'allows composite operators', ->
      checkSingleToken 'lteqop', '<='


  it 'allows string literals', ->
    checkSingleToken 'String', 'some_string'

  it 'ignores whitespaces', ->
    tokens = deflate fsm.tokenize ' 1    < 2   '
    expect(tokens).toEqual [
      kind: 'Number'
      token: '1'
      start: 1
      end: 1
    ,
      kind: 'ltop'
      token: '<'
      start: 6
      end: 6
    ,
      kind: 'Number'
      token: '2'
      start: 8
      end: 8
    ]

  it 'allows simpler expressions', ->
    tokens = deflate fsm.tokenize '1<2'
    expect(tokens).toEqual [
      kind: 'Number'
      token: '1'
      start: 0
      end: 0
    ,
      kind: 'ltop'
      token: '<'
      start: 1
      end: 1
    ,
      kind: 'Number'
      token: '2'
      start: 2
      end: 2
    ]

  it 'allows simple expressions with literals', ->
    tokens = deflate fsm.tokenize 'value<2'
    expect(tokens).toEqual [
      kind: 'String'
      token: 'value'
      start: 0
      end: 4
    ,
      kind: 'ltop'
      token: '<'
      start: 5
      end: 5
    ,
      kind: 'Number'
      token: '2'
      start: 6
      end: 6
    ]

  it 'allows simple expressions', ->
    tokens = deflate fsm.tokenize '1<=2'
    expect(tokens).toEqual [
      kind: 'Number'
      token: '1'
      start: 0
      end: 0
    ,
      kind: 'lteqop'
      token: '<='
      start: 1
      end: 2
    ,
      kind: 'Number'
      token: '2'
      start: 3
      end: 3
    ]

  it 'allows long expression', ->
    tokens = deflate fsm.tokenize '.1<=2.1e-5<000.1'
    expect(tokens).toEqual [
      kind: 'Number'
      token: '.1'
      start: 0
      end: 1
    ,
      kind: 'lteqop'
      token: '<='
      start: 2
      end: 3
    ,
      kind: 'Number'
      token: '2.1e-5'
      start: 4
      end: 9
    ,
      kind: 'ltop'
      token: '<'
      start: 10
      end: 10
    ,
      kind: 'Number'
      token: '000.1'
      start: 11
      end: 15
    ]

  it 'allows AND', ->
    input = 'a < 5 and b < 2'
    tokens = deflate fsm.tokenize input
    expect(_.map(tokens, (d) -> d.token).join(' ')).toBe input
