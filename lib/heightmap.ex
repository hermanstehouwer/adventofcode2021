defmodule HM do

  def get_neighbours({x,y}) do
    [{-1,0}, {1,0}, {0,-1}, {0,1}]
    |> Enum.map(fn {c,d} -> {x+c, y+d} end)
  end

  def is_lowpoint?(coord, heightmap)
  def is_lowpoint?({x,y}, heightmap) do
    comp = heightmap[{x,y}]
    get_neighbours({x,y})
    |> Enum.map(fn {c,d} -> comp < Map.get(heightmap, {c, d}, 10) end)
    |> Enum.all?()
  end

  def get_lowpoints(heightmap) do
    Map.keys(heightmap)
    |> Enum.filter(fn x -> HM.is_lowpoint?(x, heightmap) end)
  end

  def calculate_risk_level(coords, heightmap) do
    Enum.map(coords, fn x -> Map.get(heightmap, x) + 1 end)
    |> Enum.sum()
  end

  def coord_to_basin(heightmap, basin, to_process, processed)
  def coord_to_basin(_heightmap, basin, [], _processed) do
    basin
  end

  def coord_to_basin(heightmap, basin, [hd|tl], processed) do
    coord_to_basin(
      heightmap,
      basin ++ Enum.filter([hd], fn x -> Map.get(heightmap, x, 9) < 9 end),
      tl ++ Enum.filter(get_neighbours(hd), fn x -> !(x in processed) and !(x in tl) and Map.get(heightmap, x, 9) < 9 end),
      processed ++ [hd]
    )
  end
end
