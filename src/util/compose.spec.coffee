compose = require './compose'

describe 'Functional Composition', () ->
  it 'composes one function', () ->
    expect(
      compose(
        (a) -> a + '1'
      )('-')
    ).toBe '-1'

  it 'composes multiple functions', () ->
    expect(
      compose(
        (a) -> a + '1'
        (a) -> a + '2'
        (a) -> a + '3'
      )('-')
    ).toBe '-123'

  it 'applies functions correctly', () ->
    expect(
      compose(
        (a) -> a[0]++; a
        (a) -> a[1]++; a
        (a) -> a[2]++; a
      )([1, 2, 3])
    ).toEqual [2, 3, 4]

  it 'applies primitives', () ->
    expect(
      compose(
        (a) -> a + 1
        (a) -> a + 1
        (a) -> a + 1
      )(0)
    ).toBe 3

  it 'non-first arg get ignored', () ->
    expect(
      compose(
        (a, b) -> [a, b]
      )('a', 'b')
    ).toEqual ['a', undefined]
