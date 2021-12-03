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

  var
    mostCommon = differences.map(proc (count: int): bool = countToBool(count))
    
  result = @[]
  for i in 1..mostCommon.len:
    result.add(mostCommon[mostCommon.len - i])

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
