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

func partOne*(data: string): int =
  var
    horizontal = 0
    depth = 0

  for command in parseData(data):
    case command.direction:
      of down:
        depth += command.magnitude
      of up:
        depth -= command.magnitude
      of forward:
        horizontal += command.magnitude
  
  result = horizontal * depth
