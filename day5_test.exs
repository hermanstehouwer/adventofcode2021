ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  test "string_to_line" do
    line_in = "0,9 -> 5,9"
    line = Line.from_string(line_in)
    assert line.start == {0,9}
    assert line.end == {5,9}
  end

  test "line to points" do
    line_in = "0,9 -> 5,9"
    line = Line.from_string(line_in)
    points = Line.get_points(line)
    assert points == [{0,9}, {1,9}, {2,9}, {3,9}, {4,9}, {5,9}]
  end

  test "diagonal line to points" do
    line_in =  "1,1 -> 3,3"
    line = Line.from_string(line_in)
    points = Line.get_points(line, true)
    assert points == [{1,1}, {2,2}, {3,3}]
  end

  test "diagonal line to points_2" do
    line_in =  "9,7 -> 7,9"
    line = Line.from_string(line_in)
    points = Line.get_points(line, true)
    assert points == [{7,9}, {8,8},{9,7}]
  end

  test "diagonal line to points_3" do
    line_in =  "3,3 -> 1,1"
    line = Line.from_string(line_in)
    points = Line.get_points(line, true)
    assert points == [{1,1}, {2,2}, {3,3}]
  end

  test "diagonal line to points_4" do
    line_in =  "7,9 -> 9,7"
    line = Line.from_string(line_in)
    points = Line.get_points(line, true)
    assert points == [{7,9}, {8,8},{9,7}]
  end

  test "diagonal line to points_5" do
    line_in =  "5,5 -> 8,2"
    line = Line.from_string(line_in)
    points = Line.get_points(line, true)
    assert points == [{5,5}, {6,4}, {7,3}, {8,2}]
  end

  test "diagonal line to points_6" do
    line_in =  "6,4 -> 2,0"
    line = Line.from_string(line_in)
    points = Line.get_points(line, true)
    IO.inspect "INSPECTING POINTS:"
    IO.inspect points
    assert points == [{2,0}, {3,1}, {4,2}, {5,3},{6,4}]
  end

  test "vent_overlap" do
    lines_in = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"
    vents = Vents.from_strings(String.split(lines_in, "\n", trim: true))
    assert length(vents.lines) == 10
    assert length(Vents.get_overlap(vents)) == 5
    #assert length(Vents.get_overlap(vents,true)) == 12
  end
end
