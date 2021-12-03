import strutils

iterator parseInts(inputData: string): int =
  for line in inputData.split(Newlines):
    if line.len > 0:
      yield parseInt(line)

func depthMeasurementIncreases*(inputData: string): int =
  var
    previous: int
    initialised: bool = false

  for current in parseInts(inputData):
    if initialised and (current > previous):
      inc result
    initialised = true
    previous = current
