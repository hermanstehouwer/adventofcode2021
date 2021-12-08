ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  test "segment_solver1" do
    input = "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe"
    s = Segments.decode_from_input(input)
    assert s.output == 8394
  end
end
