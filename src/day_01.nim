import strutils, sequtils, math

iterator parseInts(inputData: string): int =
  for line in inputData.split(Newlines):
    if line.len > 0:
      yield parseInt(line)

func countIncreases(values: seq[int]): int =
  var
    previous: int
    initialised: bool = false

  for current in values:
    if initialised and (current > previous):
      inc result
    initialised = true
    previous = current

type
  UnorderedBuffer[I: static[int], T] = ref object
    values: array[I, T]
    current: int
    full: bool

proc store[I, T](this: UnorderedBuffer[I, T], value: T): void =
  this.values[this.current] = value
  inc this.current
  if this.current == I:
    this.current = 0
    this.full = true

proc get[I, T](this: UnorderedBuffer[I, T]): array[I, T] =
  let copy = this.values
  result = copy

proc full(this: UnorderedBuffer): bool =
  result = this.full

iterator windows[I: static[int], T](values: seq[T]): array[I, T] =
  var
    buffer = UnorderedBuffer[I, T]()

  for value in values:
    buffer.store(value)
    if buffer.full:
      yield buffer.get

iterator summedWindows[I: static[int]](values: seq[int]): int =
  # TODO: figure out why we can't just map over this
  for window in windows[I, int](values):
    yield sum(window)

func partTwo*(data: string): int =
  var
    values = toSeq(parseInts(data))

  result = countIncreases(toSeq(summedWindows[3](values)))

func partOne*(data: string): int =
  countIncreases(toSeq(parseInts(data)))
