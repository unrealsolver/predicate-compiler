import _ from 'underscore'
import { Node, rpnToAst } from './rpnToAst'
import { NumTok, StrTok, LtTok, AndTok } from 'tokenize/token'

describe 'RPN To AST/', ->
  it 'accepts simple RPN', ->
    expect(
      rpnToAst [StrTok('val'), NumTok(0), LtTok]
    ).toEqual(
      new Node(LtTok, StrTok('val'), NumTok(0))
    )

  it 'accepts more sophisticated RPN', ->
    expect(
      rpnToAst [StrTok('val'), NumTok(0), LtTok, StrTok('lav'), NumTok(1), LtTok, AndTok]
    ).toEqual(
      new Node(
        AndTok,
        new Node(
          LtTok,
          StrTok('val'), NumTok(0)
        ),
        new Node(
          LtTok
          StrTok('lav'), NumTok(1)
        )
      )
    )
