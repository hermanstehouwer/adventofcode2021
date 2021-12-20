ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def example() do
    "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"
    |> String.split("\n\n")
    |> Enum.map(&(String.split(&1,"\n", trim: true)))
    |> Enhance.from_input()
  end

  test "all_tests" do
    example = example()
    stepped = Enhance.steps(example, 2)
    assert length(Map.keys(stepped.image)) == 35
    stepped = Enhance.steps(example, 50)
    assert length(Map.keys(stepped.image)) == 3351

  end
end
