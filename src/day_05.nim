import strutils, sequtils

type
  Point = object
    x, y: int
  Line = object
    start, finish: Point
  Direction = enum
    vertical, horizontal, diagonal

method direction(this: Line): Direction {.base.} =
  if this.start.x == this.finish.x:
    return vertical
  elif this.start.y == this.finish.y:
    return horizontal
  else:
    return diagonal

iterator points(line: Line): Point =
  case line.direction:
    of vertical:
      for y in line.start.y..line.finish.y:
        yield Point(x: line.start.x, y: y)
    of horizontal:
      for x in line.start.x..line.finish.x:
        yield Point(x: x, y: line.start.y)
    of diagonal:
      raise newException(
        Exception, "Point iteration for diagonal lines is not implemented"
      )

func parseLine(data: string): Line =
  let
    points = data.split(" -> ")
  
  assert points.len == 2
  let
    start = points[0].split(',')
    finish = points[1].split(',')

  assert start.len == 2
  assert finish.len == 2

  return Line(
    start: Point(x: parseInt(start[0]), y: parseInt(start[1])),
    finish: Point(x: parseInt(finish[0]), y: parseInt(finish[1])),
  )

func partOne*(data: string): int =
  let
    lines = data.splitLines.map(parseLine)

  # This will be incredibly slow but try anyway
  var
    overlaps: array[1000, array[1000, int8]]
    doubleOverlapCount: int

  for line in lines:
    if line.direction == diagonal:
      continue
    for point in line.points:
      var
        current = overlaps[point.x][point.y]
      if current < high(int8):
        inc overlaps[point.x][point.y]
        if current == 1: # Hence it just became two
          inc doubleOverlapCount

  return doubleOverlapCount
