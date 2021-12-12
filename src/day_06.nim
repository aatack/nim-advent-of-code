import options, sequtils, strutils, sugar

type
  Lanternfish = ref object
    days: int
  School = ref object
    fish: seq[Lanternfish]

method loop(this: Lanternfish): Option[Lanternfish] =
  dec this.days
  if this.days < 0:
    this.days = 6
    return some(Lanternfish(days: 8))

method loop(this: School) =
  var
    newborns = this.fish.map(loop)
  
  for fish in newborns:
    if fish.isSome:
      this.fish.add(fish.get)

proc parseSchool(data: string): School =
  return School(
    fish: data.readLines.map(parseInt).map(i => Lanternfish(days: i))
  )
