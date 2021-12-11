import sugar
import strutils, sequtils

type
  Bingo[I: static[int]] = ref object
    # We can store marked numbers as -1 as they are not needed during scoring
    numbers: array[I, array[I, int]]
    row_hits: array[I, int]
    column_hits: array[I, int]
    diagonal_hits: int
    off_diagonal_hits: int

func parseBoard[I](lines: seq[string]): Bingo[I] =
  assert lines.len == I
  var
    board = Bingo[I]()

  for row, line in lines:
    var
      columns = line.splitWhitespace.filter(c => c.len > 0).map(parseInt)
    assert columns.len == I
    for column, number in columns:
      board.numbers[row][column] = number

  return board

proc draw[I](this: Bingo[I], number: int): void =
  assert number >= 0

  for row in 0..(I - 1):
    for column in 0..(I - 1):
      if this.numbers[row][column] == number:
        this.numbers[row][column] = -1

        inc this.row_hits[row]
        inc this.column_hits[column]
        if row == column:
          inc this.diagonal_hits
        if row == I - (column + 1):
          inc this.off_diagonal_hits

func score[I](this: Bingo[I]): int =
  # Does not assume the game has been completed
  var
    total = 0

  for row in 0..(I - 1):
    for column in 0..(I - 1):
      let
        square = this.numbers[row][column]
      if square != -1:
        total += square

  return total

func won[I](this: Bingo[I]): bool =
  for value in this.row_hits:
    if value >= I:
      return true
  for value in this.column_hits:
    if value >= I:
      return true
  return this.diagonal_hits >= I or this.off_diagonal_hits >= I

func splitWhere[T](sequence: seq[T], where: T -> bool): seq[seq[T]] =
  var
    segment: seq[T]
    segments: seq[seq[T]]
  
  for value in sequence:
    if where(value):
      segments.add(segment)
      segment = @[]
    else:
      segment.add(value)

  segments.add(segment)
  return segments

func parseData[I](data: string): (seq[int], seq[Bingo[I]]) =
  let
    sections = splitWhere[string](data.splitLines, (l: string) => l.len == 0)
    draws = sections[0]
    boards = sections[1..(sections.len - 1)]

  assert draws.len == 1

  return (draws[0].split(',').map(parseInt), boards.map(parseBoard[I]))

proc partOne*(data: string): int =
  let
    (draws, boards) = parseData[5](data)
    
  for number in draws:
    for board in boards:
      board.draw(number)
      if board.won:
        return board.score
