import strutils

type
  Direction = enum
    forward, down, up
  Command = object
    direction: Direction
    magnitude: int

func parseCommand(line: string): Command =
  let
    segments = line.split
  assert segments.len == 2
  return Command(
    direction: (
      case segments[0]:
        of "forward":
          forward
        of "down":
          down
        of "up":
          up
        else:
          raise newException(Exception, "Invalid direction: " & segments[0])
    ),
    magnitude: parseInt(segments[1])
  )

iterator parseData*(data: string): Command =
  for line in data.splitLines:
    yield parseCommand(line)

proc partOne*(data: string): int =
  # TODO: change back to func
  for command in parseData(data):
    discard
  0
