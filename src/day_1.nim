import strutils, sequtils

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
