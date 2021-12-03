import strutils, sequtils

type
  UnorderedBuffer*[I: static[int], T] = ref object
    values: array[I, T]
    current: int

method store*[I, T](this: UnorderedBuffer[I, T], value: T): void {.base.} =
  this.values[this.current] = value
  inc this.current
  if this.current == I:
    this.current = 0

method get*[I, T](this: UnorderedBuffer[I, T]): array[I, T] {.base.} =
  let copy = this.values
  result = copy

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

func depthMeasurementIncreases*(inputData: string): int =
  countIncreases(toSeq(parseInts(inputData)))
