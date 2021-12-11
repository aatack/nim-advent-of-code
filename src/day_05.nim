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
