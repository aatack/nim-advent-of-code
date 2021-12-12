import options, sequtils, strutils, sugar

const
  normalGestation = 6
  newbornGestation = 8

type
  Lanternfish = ref object
    days: int
  School = ref object
    fish: seq[Lanternfish]
  IndexedSchool = ref object
    fish: array[newbornGestation + 1, int]

method loop(this: Lanternfish): Option[Lanternfish] {.base.} =
  dec this.days
  if this.days < 0:
    this.days = normalGestation
    return some(Lanternfish(days: newbornGestation))

method loop(this: School) {.base.} =
  var
    newborns = this.fish.map(loop)
  
  for fish in newborns:
    if fish.isSome:
      this.fish.add(fish.get)

method loop(this: IndexedSchool) =
  let
    due = this.fish[0] # Fish that are about to give birth
  for i in 0..(newbornGestation - 1):
    this.fish[i] = this.fish[i + 1]
  this.fish[newbornGestation] = due
  this.fish[normalGestation] = due

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
