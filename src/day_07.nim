import strutils, sequtils

func cost(positions: seq[int], position: int): int =
  var
    total = 0

  for p in positions:
    total += abs(p - position)
  return total

func partOne*(data: string): int =
  let
    positions = data.split(',').map(parseInt)

  var
    currentMinimumCost = high(int)
  
  for position in 0..positions.max:
    let
      positionCost = cost(positions, position)
    if positionCost < currentMinimumCost:
      currentMinimumCost = positionCost

  return currentMinimumCost
