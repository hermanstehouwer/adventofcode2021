ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def example() do
    "v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>"
    |> String.split("\n")
  end

  test "small_test" do
    ran = example()
    |> AOC_input.to_coord_map_chars(0) |> Map.new()
    |> Cucumber.init()
    |> Cucumber.stepping()
    assert ran.steps == 58



  end
end
