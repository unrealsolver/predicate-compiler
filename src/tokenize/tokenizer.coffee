import _ from 'underscore'

grammar = [
  # ENTRY
  name: '*'
  matcher: /./
  next: ['num', 'dot', 'lt', 'strlit', 'ws']
,
  # WHITESPACE
  name: 'ws'
  matcher: /\s/
  next: ['ws', '*']
  token: 'ws'
,
  name: 'strlit'
  matcher: /\w/
  next: ['strlit', '*']
  token: 'String'
,
  # NUMBER
  name: 'num'
  matcher: /\d/
  next: ['num', 'dot', 'exp', '*']
  token: 'Number'
,
  name: 'dot'
  matcher: /\./
  next: ['num-f']
  token: 'Number'
,
  name: 'exp'
  matcher: /\e/
  next: ['num-e', 'e+', 'e-']
,
  name: 'e+'
  matcher: /\+/
  next: ['num-e']
,
  name: 'e-'
  matcher: /\-/
  next: ['num-e']
,
  name: 'num-f'
  matcher: /\d/
  next: ['num-f', 'exp', '*']
  forbid: ['dot']
,
  name: 'num-e'
  matcher: /\d/
  next: ['num-e', '*']
  forbid: ['dot']
,
  # ERROR
  name: 'error'
  matcher: null
  next: null
  token: 'Error!'
,
  # TERMINAL
  name: 'T'
  matcher: /\n/
  next: null
,
  # OPS
  name: 'lt'
  matcher: /</
  next: ['lt+eq', '*']
  token: 'ltop'
,
  name: 'lt+eq'
  matcher: /\=/
  next: ['*']
  token: 'lteqop'
]

getState = (name) -> _.findWhere grammar, {name}
tokens = []
TERMINAL = '[T]'

# TODO Do I understand how does this thing work? Heck, NO... :D
createFSM = (graph) ->
  sequence = ''
  initial = getState '*'
  T = getState 'T'
  WS = getState 'ws'
  state = initial
  enteredToken = undefined
  tokenStart = undefined
  tokenEnd = undefined
  restarted = true
  idx = 0

  getNextState = (symbol) ->
    if symbol is TERMINAL and '*' in state.next then return T.name
    _.find state.next, (sn) ->
      s = getState sn
      s.matcher.test symbol

  getForbiddenState = (symbol) ->
    _.find state.forbid, (sn) ->
      s = getState sn
      s.matcher.test symbol

  step = (symbol) ->
    nextStateId = getNextState symbol
    forbiddenTransition = getForbiddenState symbol
    if forbiddenTransition
      throw new Error(
        "Forbidden transition [#{state.name} -> #{forbiddenTransition}] " +
        "for '#{symbol}' in '#{sequence}'"
      )

    nextState = getState nextStateId
    unless nextState
      throw new Error(
        """Unexpected symbol '#{symbol}' at '#{sequence}'! Expected [#{state.next}]
          #{Array(idx + 35).join(' ')}~^"""
      )

    tokenName = state.token

    if restarted
      tokenStart = idx
      enteredToken = if tokenName
        tokenName
      else
        nextState.token

    restarted = nextStateId == '*'

    if restarted or nextState is T
      tokenEnd = idx - 1
      token =
        end: tokenEnd
        start: tokenStart
        kind: if tokenName
          tokenName
        else
          enteredToken
        token: sequence[tokenStart..tokenEnd]
      state = initial
      nextStateId = getNextState symbol

    if nextState is T
      return token unless token.kind is 'ws'

    if restarted
      step symbol
      return token unless token.kind is 'ws'
    else
      state = getState(nextStateId or 'error')
      idx++
    return


  tokenize = (seq) ->
    state = initial
    enteredToken = undefined
    tokenStart = undefined
    tokenEnd = undefined
    restarted = true
    idx = 0
    # TODO Trim or not to trim? Breaks start/end range detection
    sequence = seq
    for sym in sequence
      token = step sym
      if token
        yield token
    token = step TERMINAL
    if token
      yield token

  tokenize: tokenize

export default createFSM grammar
