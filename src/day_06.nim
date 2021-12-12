import options, sequtils, strutils, sugar

type
  Lanternfish = ref object
    days: int
  School = ref object
    fish: seq[Lanternfish]

method loop(this: Lanternfish): Option[Lanternfish] {.base.} =
  dec this.days
  if this.days < 0:
    this.days = 6
    return some(Lanternfish(days: 8))

method loop(this: School) {.base.} =
  var
    newborns = this.fish.map(loop)
  
  for fish in newborns:
    if fish.isSome:
      this.fish.add(fish.get)

func parseSchool(data: string): School =
  return School(
    fish: data.split(',').map(parseInt).map(i => Lanternfish(days: i))
  )

func partOne*(data: string): int =
  var
    school = parseSchool(data)
  
  for _ in 1..80:
    school.loop
  return school.fish.len
