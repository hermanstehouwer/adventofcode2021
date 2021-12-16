defmodule Chiton do
  @type coordinate::{integer(), integer()}

  @spec expand_map(%{coordinate() => integer})::%{coordinate() => integer()}
  def expand_map(map) do
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

  @spec get_neighbours(coordinate(), coordinate())::[coordinate()]
  def get_neighbours({x,y}, {mx,my}) do
    [{x-1,y}, {x + 1,y}, {x,y-1}, {x,y+1}]
    |> Enum.reject(fn {c,d} -> c < 0 or c > mx or d < 0 or d > my end)
  end

  @spec get_corner_distance(%{coordinate() => integer})::integer()
  def get_corner_distance(path_map) do
    tgt = Map.keys(path_map) |> Enum.sort() |> List.last()
    Map.get(path_map, tgt,  :infinity)
  end

  @spec manhattan(coordinate(), coordinate())::integer()
  # For specific usecase. We only measure until the end, so c > x and d > y!
  def manhattan({x,y}, {c,d}) do
    (c - x) + (d - y)
  end

  @spec compute_all_paths(%{coordinate() => integer})::%{coordinate() => integer()}
  def compute_all_paths(map) do
    start = {0,0}
    goal = Map.keys(map) |> Enum.sort() |> List.last()
    openset = [start]
    camefrom = %{}
    gScore = %{start => 0}
    fScore = %{start => manhattan(start, goal)}
    a_star(map, camefrom, gScore, fScore, goal, openset)
  end

  @spec a_star_inner(
    %{coordinate() => integer}, #map
    coordinate(), #current
    coordinate(), #goal
    %{coordinate() => coordinate()}, #camefrom
    %{coordinate() => integer()}, #gScore
    %{coordinate() => integer()}, #fScore
    [coordinate()], #openset
    [coordinate()]  #neighbours
  )::%{coordinate() => integer()}
  def a_star_inner(map, current, goal, camefrom, gScore, fScore, openset, neighboars)

  def a_star_inner(_map, _current, _goal, camefrom, gScore, fScore, openset, []) do
    {camefrom, gScore, fScore, openset}
  end

  def a_star_inner(map, current, goal, camefrom, gScore, fScore, openset, [nb|nb_tl]) do
    tentative_gScore = gScore[current] + map[nb]
    if tentative_gScore < Map.get(gScore, nb, :infinity) do
      a_star_inner(
        map,
        current,
        goal,
        Map.put(camefrom, nb, current),
        Map.put(gScore, nb, tentative_gScore),
        Map.put(fScore, nb, tentative_gScore + manhattan(nb, goal)),
        [nb|openset],
        nb_tl)
    else
      a_star_inner(map, current, goal, camefrom, gScore, fScore, openset, nb_tl)
    end
  end

  @spec a_star(
    %{coordinate() => integer}, #map
    %{coordinate() => coordinate()}, #camefrom
    %{coordinate() => integer()}, #gScore
    %{coordinate() => integer()}, #fScore
    coordinate(),   #goal
    [coordinate()]  #openset
  )::%{coordinate() => integer()}
  def a_star(map, camefrom, gScore, fScore, goal, openset)

  def a_star(_map, _camefrom, gScore, _fScore, _goal, []) do
    gScore
  end

  def a_star(_map, _camefrom, gScore, _fScore, goal, [goal|_]) do
    gScore
  end

  def a_star(map, camefrom, gScore, fScore, goal, [current|openset]) do
    {camefrom, gScore, fScore, openset} = a_star_inner(map, current, goal, camefrom, gScore, fScore, openset, get_neighbours(current, goal))
    openset = openset |> Enum.sort(fn x, y -> fScore[x] <= fScore[y] end) |> Enum.uniq()
    a_star(map, camefrom, gScore, fScore, goal, openset)
  end
end
