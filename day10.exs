lines = AOC_input.get_day_simple(10)

#part1
Enum.map(lines,
fn x -> SyntaxScoring.match_and_score(
  %SyntaxScoring{},
  String.split(x, "", trim: true),
  [])
  end)
|> Enum.sum()
|> IO.inspect()

#part2
a = Enum.map(lines,
fn x -> SyntaxScoring.match_and_score(
  %SyntaxScoring{},
  String.split(x, "", trim: true),
  [],
  true)
  end)
|> Enum.filter(fn x -> x != 0 end)
|> Enum.sort()

IO.inspect Enum.at(a, div(length(a), 2))
