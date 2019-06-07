import _ from 'underscore'
import parse from './parser.coffee'
import { NumTok, StrTok, LtTok, AndTok } from 'tokenize/token'


describe 'Parser/', ->
  it 'parses', ->
    rpn = parse [NumTok(10), LtTok, NumTok(20)]
    expect(rpn[0].token).toBe '10'
    expect(rpn[1].token).toBe '20'
    expect(rpn[2].token).toBe '<'

  it 'parses1', ->
    rpn = parse [StrTok('value'), LtTok, NumTok(20)]
    expect(rpn[0].token).toBe 'value'
    expect(rpn[1].token).toBe '20'
    expect(rpn[2].token).toBe '<'

  it 'parses2', ->
    rpn = parse [
      StrTok('a'), LtTok, NumTok(1), AndTok, StrTok('b'), LtTok, NumTok(2)
    ]
    expect(_.map rpn, (d) -> d.token).toEqual [
      'a', '1', '<', 'b', '2', '<', 'and'
    ]
