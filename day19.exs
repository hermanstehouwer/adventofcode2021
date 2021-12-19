scanners = AOC_input.get_day_double(19) |> Enum.map(&Scanner.from_strings/1)
scanners = Scanner.reconstruct(scanners)

#part1:
Enum.reduce(scanners, [], &Scanner.reduce_scanners/2)
|> Enum.uniq()
|> length()
|> IO.inspect()

#part2:
for x <- scanners, y <- scanners do
  Scanner.manhattan(x, y)
end
|> Enum.max()
|> IO.inspect()
