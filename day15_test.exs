ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def ex1() do
    "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581" |> String.split("\n", trim: true)
  end

  test "part1" do
    map = AOC_input.to_coord_map_ints(ex1(), 0) |> Map.new()
    path_map = Chiton.compute_all_paths(map)
    assert Chiton.get_corner_distance(path_map) == 40
  end

  test "expander" do
    map = Map.new([{{0,0}, 8}]) |> Chiton.expand_map()
    assert map[{4,4}] == 7
  end

  test "part2" do
    map = AOC_input.to_coord_map_ints(ex1(), 0) |> Map.new() |> Chiton.expand_map()
    path_map = Chiton.compute_all_paths(map)
    assert Chiton.get_corner_distance(path_map) == 315
  end
end
