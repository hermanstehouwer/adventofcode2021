all_cubes = AOC_input.get_day_simple(22) |> Enum.map(&Cube.from_string/1)

#part1
p1_cubes = Enum.take(all_cubes, 20)
processed = Enum.reduce(p1_cubes, [], &Cube.reduce/2)
Enum.sum(Enum.map(processed, &Cube.lit/1)) |> IO.inspect()

#part2
processed = Enum.reduce(all_cubes, [], &Cube.reduce/2)
Enum.sum(Enum.map(processed, &Cube.lit/1)) |> IO.inspect()
