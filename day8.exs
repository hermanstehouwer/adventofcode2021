#Part 1
AOC_input.get_day_simple(8)
|> Enum.map(fn x -> String.split(x, " | ", trim: True) end)
|> Enum.map(fn [_x,y]->y end)
|> Enum.map(&String.split/1)
|> List.flatten()
|> Enum.filter(fn x -> String.length(x) in [2,3,4,7] end)
|> length()
|> IO.inspect()

#Part2
AOC_input.get_day_simple(8)
|> Enum.map(&Segments.decode_from_input/1)
|> Enum.map(fn s -> s.output end)
|> Enum.sum()
|> IO.inspect()
