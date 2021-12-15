map = AOC_input.get_day_simple(15) |> AOC_input.to_coord_map_ints(0) |> Map.new()

#part1
path_map = Chiton.compute_all_paths(map)
IO.inspect Chiton.get_corner_distance(path_map)

#part2
map = Chiton.expand_map(map)
IO.inspect "calculating ...."
path_map = Chiton.compute_all_paths(map)
IO.inspect Chiton.get_corner_distance(path_map)
