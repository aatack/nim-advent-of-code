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
    if count < 0:
      result = false
    elif count > 0:
      result = true
    else:
      raise newException(Exception, "Equal number of 0s and 1s")

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

func argmax(values: seq[int]): int =
  0

func sharedLeadingBits(number: Binary): (Binary) -> int =
  result = (b: Binary) => 0

func partOne*(data: string): int =
  var
    mostCommon = mostCommonBits(parseData(data))
    leastCommon = invert(mostCommon)
  result = mostCommon.toDecimal * leastCommon.toDecimal

func partTwo*(data: string): int =
  var
    numbers = parseData(data)
    mostCommon = mostCommonBits(numbers)
    leastCommon = invert(mostCommon)

  result = (
    toDecimal(numbers[argmax(numbers.map(sharedLeadingBits(mostCommon)))]) *
    toDecimal(numbers[argmax(numbers.map(sharedLeadingBits(leastCommon)))])
  )
