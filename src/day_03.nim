import strutils, sequtils

type
  Binary = seq[bool] # Little-endian

func countToBool(count: int): bool =
  # Positive difference means there are more ones; mapped to true
  if count < 0:
    result = false
  elif count > 0:
    result = true
  else:
    raise newException(Exception, "Equal number of 0s and 1s")

func reverse[T](sequence: seq[T]): seq[T] =
  result = @[]
  for i in 1..sequence.len:
    result.add(sequence[sequence.len - i])

func mostCommonBits(data: seq[string]): Binary =
  var
    differences: seq[int]

  for line in data:
    if differences.len == 0:
      differences = newSeq[int](line.len)
    
    for i, bit in line:
      case bit:
        of '0':
          dec differences[i]
        of '1':
          inc differences[i]
        else:
          raise newException(Exception, "Invalid bit: " & bit)

  result = reverse(differences.map(countToBool))

func fromBinary(binary: Binary): int =
  var
    total = 0
    place = 1

  for bit in binary:
    if bit:
      total += place
    place *= 2

  result = total

proc partOne*(data: string): int =
  var
    mostCommon = mostCommonBits(data.splitLines)

  result = fromBinary(mostCommon) * fromBinary(mostCommon.map(
    proc (bit: bool): bool = not bit
  ))
