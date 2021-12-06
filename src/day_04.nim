type
  Bingo*[I: static[int]] = ref object
    # Score is calculated by finding the sum of all unmarked numbers; we can
    # therefore store marked numbers simply as 0, since they will not impact it
    numbers*: array[I, array[I, int]]
    row_hits: array[I, int]
    column_hits*: array[I, int]
    diagonal_hits: int
    off_diagonal_hits: int

proc draw*[I](this: Bingo[I], number: int): void =
  for row in 0..(I - 1):
    for column in 0..(I - 1):
      if this.numbers[row][column] == number:
        this.numbers[row][column] = 0

        inc this.row_hits[row]
        inc this.column_hits[column]
        if row == column:
          inc this.diagonal_hits
        if row == I - (column + 1):
          inc this.off_diagonal_hits

proc score*[I](this: Bingo[I]): int =
  # Does not assume the game has been completed
  var
    total = 0

  for row in 0..(I - 1):
    for column in 0..(I - 1):
      total += this.numbers[row][column]

  return total
