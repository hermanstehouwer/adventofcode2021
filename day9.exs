
heightmap = AOC_input.get_day_coord_map_ints(9)
lowpoints = HM.get_lowpoints(heightmap)
HM.calculate_risk_level(lowpoints, heightmap)
|> IO.inspect

basins = HM.get_lowpoints(heightmap) |> Enum.map(fn x-> HM.coord_to_basin(heightmap, [], [x]) end)
[a,b,c|_d] = Enum.map(basins, fn x -> length(x) end)
|> Enum.sort()
|> Enum.reverse()
IO.inspect a*b*c
