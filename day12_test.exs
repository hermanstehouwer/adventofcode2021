ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  def ex1() do
    "start-A
start-b
A-c
A-b
b-d
A-end
b-end"
  end

  def ex2() do
    "dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"
  end

  def ex3() do
    "fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW"
  end

  def testing(input, expected, twice) do
    paths = input
    |> String.split("\n", trim: true)
    |> Passages.input_to_graph()
    |> Passages.find_all_paths(["start"], twice)
    assert length(paths) == expected
  end

  test "tests" do
    testing(ex1(),10,false)
    testing(ex1(),36,true)
    testing(ex2(),19,false)
    testing(ex2(),103,true)
    testing(ex3(),226,false)
    testing(ex3(),3509,true)
  end
end
