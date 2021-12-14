ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def ex1() do
    "NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"
  end

  test "tests" do
    [[part1], part2] = ex1() |> String.split("\n\n", trim: true) |> Enum.map(fn x -> String.split(x, "\n", trim: true) end)
    rules = Polymer.input_to_rules(part2)

    IO.inspect(rules)

    [hd|tl] = String.split(part1, "", trim: true)
    input = Enum.zip([hd|tl], tl) |> Enum.frequencies()

    test3 = Polymer.apply_rules(rules, input, 10)
    assert Polymer.score(test3) == 1588

    test4 = Polymer.apply_rules(rules, input, 40)
    assert Polymer.score(test4) == 2188189693529
  end
end
