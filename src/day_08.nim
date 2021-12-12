import strutils, sequtils

type
  Segment = enum
    a, b, c, d, e, f, g
  Reading = set[Segment]
  Display = object
    potential: array[10, Reading]
    displayed: array[4, Reading]

const
  originalReadings = [
    {a, b, c, e, f, g},
    {c, f},
    {a, c, d, e, g},
    {a, c, d, f, g},
    {b, c, d, f},
    {a, b, d, f, g},
    {a, b, d, e, f, g},
    {a, c, f},
    {a, b, c, d, e, f, g},
    {a, b, c, d, f, g},
  ]

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

func getSegmentMapping(display: Display): array[Segment, Segment] =
  # Return a mapping of displayed segments to actual segments
  result[d] = a
  result[e] = b
  result[a] = c
  result[f] = d
  result[g] = e
  result[b] = f
  result[c] = g

func readingToInt(reading: Reading): int =
  for i, r in originalReadings:
    if r == reading:
      return i

  raise newException(Exception, "Unrecognised reading: " & $reading)

func displayToInt(display: Display): int =
  let
    mapping = getSegmentMapping(display)
  var
    stringReading = ""

  for reading in display.displayed:
    var
      mappedReading: Reading = {}
    for segment in reading:
      mappedReading.incl(mapping[segment])
    stringReading = stringReading & $readingToInt(mappedReading)

  return parseInt(stringReading)

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

proc partTwo*(data: string): int =
  let
    displays = data.splitLines.map(parseDisplay)
