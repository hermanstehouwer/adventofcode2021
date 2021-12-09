ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def test_map() do
    "2199943210
3987894921
9856789892
8767896789
9899965678"
    |> String.split("\n", trim: true)
    |> AOC_input.to_coord_map_ints(0)
    |> Map.new()
  end

  test "debug_specific_coord" do
    heightmap = test_map()
    assert HM.is_lowpoint?({0,0}, heightmap) == false
  end

  test "p1_test" do
    heightmap = test_map()
    lowpoints = HM.get_lowpoints(heightmap)
    assert HM.calculate_risk_level(lowpoints, heightmap) == 15
  end

  test "p2_test" do
    heightmap = test_map()
    basins = HM.get_lowpoints(heightmap) |> Enum.map(fn x-> HM.coord_to_basin(heightmap, [], [x], []) end)
    [a,b,c|_d] = Enum.map(basins, fn x -> length(x) end)
    |> Enum.sort()
    |> Enum.reverse()
    assert a * b * c == 1134
  end
end
