ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def test_map_1() do
    "11111
19991
19191
19991
11111"
    |> String.split("\n", trim: true)
    |> AOC_input.to_coord_map_ints(0)
    |> Map.new()
  end

  def test_map_2() do
    "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"
    |> String.split("\n", trim: true)
    |> AOC_input.to_coord_map_ints(0)
    |> Map.new()
  end

  def comp_map_2_steps() do
    "8807476555
5089087054
8597889608
8485769600
8700908800
6600088989
6800005943
0000007456
9000000876
8700006848"
    |> String.split("\n", trim: true)
    |> AOC_input.to_coord_map_ints(0)
    |> Map.new()
  end

  test "2-steps-small" do
    oct = Octopus.step(%Octopus{octopi: test_map_1()}, 2)
    assert oct.flashes == 9
  end

  test "2-steps" do
    oct = Octopus.step(%Octopus{octopi: test_map_2()}, 1)
    assert oct.flashes == 0
    oct2 = Octopus.step(oct, 1)
    assert oct2.flashes == 35
    assert oct2.octopi == comp_map_2_steps()
  end

  test "10-steps" do
    oct = Octopus.step(%Octopus{octopi: test_map_2()}, 10)
    assert oct.flashes == 204
  end

  test "100-steps" do
   oct = Octopus.step(%Octopus{octopi: test_map_2()}, 100)
    assert oct.flashes == 1656
  end

  test "flashing" do
    oct = Octopus.step(%Octopus{octopi: test_map_2()}, -1, true)
    assert oct.steps == 195
  end
end
