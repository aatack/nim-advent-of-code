import strutils, sequtils, sugar

type
  Binary = seq[bool] # Little-endian

func parseBinary(line: string): Binary =
  result = @[]
  for bit in line:
    case bit:
      of '0':
        result.add(false)
      of '1':
        result.add(true)
      else:
        raise newException(Exception, "Invalid bit: " & bit)

func parseData(data: string): seq[Binary] =
  data.splitLines.map(parseBinary)

func invert(number: Binary): Binary =
  number.map((bit: bool) => not bit)

func mostCommonBits(numbers: seq[Binary]): Binary =
  var
    counts: seq[int] # Positive count means there are more ones
  
  for number in numbers:
    while counts.len < number.len:
      counts.add(0)
    for i, bit in number:
      if bit:
        inc counts[i]
      else:
        dec counts[i]

  func countToBool(count: int): bool =
    # Positive difference means there are more ones; mapped to true
    return count >= 0

  result = counts.map(countToBool)

func toDecimal(number: Binary): int =
  var
    total = 0
    place = 1

  func reverse[T](sequence: seq[T]): seq[T] =
    result = @[]
    for i in 1..sequence.len:
      result.add(sequence[sequence.len - i])

  for bit in reverse(number):
    if bit:
      total += place
    place *= 2

  result = total

func filterNonMatching(
  numbers: seq[Binary], accumulator: (seq[Binary]) -> Binary
): Binary =
  var
    remaining = numbers
    accumulated: Binary
    index = 0

  while remaining.len > 1:
    accumulated = accumulator(remaining)
    remaining = remaining.filter(
      (number) => number[index] == accumulated[index]
    )
    inc index

  assert remaining.len == 1
  return remaining[0]

func partOne*(data: string): int =
  var
    mostCommon = mostCommonBits(parseData(data))
    leastCommon = invert(mostCommon)
  result = mostCommon.toDecimal * leastCommon.toDecimal

func partTwo*(data: string): int =
  var
    numbers = parseData(data)

  return (
    filterNonMatching(numbers, mostCommonBits).toDecimal *
    filterNonMatching(numbers, (n) => mostCommonBits(n).invert).toDecimal
  )
