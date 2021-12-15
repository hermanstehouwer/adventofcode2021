defmodule Chiton do
  @type coordinate::{integer(), integer()}

  def expand_map(map) do
    IO.inspect("Expanding map 5 fold")
    {mx, my} = Map.keys(map) |> Enum.sort() |> List.last()

    tile_coords = Map.to_list(map)
    for x_xp <- 0..4 do
      for y_xp <- 0..4 do
        Enum.map(tile_coords,
          fn {{x, y}, v} ->
            {
              {(mx+1)*x_xp + x, (my+1)*y_xp + y},
              rem(v + x_xp + y_xp - 1, 9) + 1
            }
          end
        )
      end
    end
    |> List.flatten()
    |> Map.new()
  end

  def get_neighbours({x,y}, {mx,my}) do
    [{-1,0}, {1,0}, {0,-1}, {0,1}]
    |> Enum.map(fn {c,d} -> {x+c, y+d} end)
    |> Enum.filter(fn {c,d} -> c >= 0 and c<= mx and d >= 0 and d <= my end)
  end

  def generate_neighbourmap({mx, my}) do
    for x <- 0..mx do
      for y <- 0..my do
        {{x,y}, get_neighbours({x,y}, {mx, my})}
      end
    end
    |> List.flatten()
    |> Map.new()
  end

  def get_corner_distance(path_map) do
    tgt = Map.keys(path_map) |> Enum.sort() |> List.last()
    Map.get(path_map, tgt,  :infinity)
  end

  def process_step(map, path_map, openset, from, to_process)

  def process_step(_map, path_map, openset, _from, []) do
    {path_map, openset}
  end

  def process_step(map, path_map, openset, from, [hd|tl]) do
    cmp = Map.get(path_map, hd, :infinity)
    from_dist = Map.get(path_map, from)
    tgt_dist = from_dist + Map.get(map, hd)
    if tgt_dist < cmp do
      new_path_map = Map.put(path_map, hd, tgt_dist)
      new_openset = [hd|openset]
      process_step(map, new_path_map, new_openset, from, tl)
      # found better path
    else
      # found worse path
      process_step(map, path_map, openset, from, tl)
    end
  end

  @spec compute_all_paths(
    %{coordinate() => integer()},
    %{coordinate() => [coordinate()]},
    %{coordinate() => integer()},
    [coordinate()]
  )::%{coordinate() => integer()}
  def compute_all_paths(map, neighbourmap\\%{}, path_map\\%{}, openset\\Nil)

  def compute_all_paths(map, _neighbourmap, _path_map, Nil) do
    IO.inspect("Initialising npm and map")
    new_path_map = %{{0,0} => 0}
    new_map = Map.put(map, {0,0}, 0)

    IO.inspect("Generating neighbourmap")
    max = Map.keys(map) |> Enum.sort() |> List.last()
    neighbourmap = generate_neighbourmap(max)

    IO.inspect("computing ...")
    compute_all_paths(new_map, neighbourmap, new_path_map, [{0,0}])
  end

  def compute_all_paths(_map, _neighbourmap, path_map, []) do
    path_map
  end

  def compute_all_paths(map, neighbourmap, path_map, [from|openset]) do
      to_process = neighbourmap[from]
      {new_path_map, new_openset} = process_step(map, path_map, openset, from, to_process)
      compute_all_paths(map, neighbourmap, new_path_map, new_openset)
  end
end
