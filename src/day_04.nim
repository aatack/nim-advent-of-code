import sugar

type
  Bingo[I: static[int]] = ref object
    # We can store marked numbers as -1 as they are not needed during scoring
    numbers: array[I, array[I, int]]
    row_hits: array[I, int]
    column_hits: array[I, int]
    diagonal_hits: int
    off_diagonal_hits: int

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

proc score[I](this: Bingo[I]): int =
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

proc won[I](this: Bingo[I]): bool =
  for value in this.row_hits:
    if value >= I:
      return true
  for value in this.column_hits:
    if value >= I:
      return true
  return this.diagonal_hits >= I or this.off_diagonal_hits >= I

func splitWhere[T](sequence: seq[T], where: (T) -> bool): seq[seq[T]] =
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
