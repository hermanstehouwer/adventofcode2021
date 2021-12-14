[[input1], ruleset] = AOC_input.get_day_double(14)
rules = Polymer.input_to_rules(ruleset)

[hd|tl] = String.split(input1, "", trim: true)
input = Enum.zip([hd|tl], tl) |> Enum.frequencies()

part1 = Polymer.apply_rules(rules, input, 10)
IO.inspect Polymer.score(part1)

part2 = Polymer.apply_rules(rules, input, 40)
IO.inspect Polymer.score(part2)
IO.inspect "Notice: off by2, so reduce above by 2"
