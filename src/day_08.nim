import strutils, sequtils

type
  Segment = enum
    a, b, c, d, e, f, g
  Reading = set[Segment]
  Display = object
    potential: array[10, Reading]
    displayed: array[4, Reading]

func parseReading(data: string): Reading =
  for character in data:
    result.incl(parseEnum[Segment]($character))

proc parseDisplay(data: string): Display =
  let
    parts = data.split(" | ")
  assert parts.len == 2, "Invalid display: '" & data & "'"
  
  for i, reading in parts[0].splitWhitespace.map(parseReading):
    result.potential[i] = reading
  for i, reading in parts[1].splitWhitespace.map(parseReading):
    result.displayed[i] = reading

func partOne*(data: string): int =
  const
    allowedLengths = {2, 3, 4, 7}

  let
    displays = data.splitLines.map(parseDisplay)
  
  var 
    count = 0

  for display in displays:
    for reading in display.displayed:
      if reading.len in allowedLengths:
        inc count

  return count
