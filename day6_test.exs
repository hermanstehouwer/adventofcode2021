ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  test "fishes_test" do
    start = [3,4,3,1,2]
    fishes = Lanternfish.fromlist(start)
    more_fishes = Lanternfish.n_steps(fishes, 18)
    assert Lanternfish.count(more_fishes) == 26
    even_more_fishes = Lanternfish.n_steps(fishes, 80)
    assert Lanternfish.count(even_more_fishes) == 5934
  end
end
