vents = AOC_input.get_day_simple(5, trim: true) |> Vents.from_strings()
IO.inspect length(Vents.get_overlap(vents))
IO.inspect length(Vents.get_overlap(vents, true))
