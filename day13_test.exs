ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def ex1() do
    "6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"
  end

  test "tests" do
    [part1, part2] = ex1() |> String.split("\n\n", trim: true) |> Enum.map(fn x -> String.split(x, "\n", trim: true) end)
    paper = Origami.input_to_paper(part1)
    processed = Enum.reduce(part2, paper, &Origami.process_instruction_reducer/2)
    assert length(processed) == 16
  end
end
