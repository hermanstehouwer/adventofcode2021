ExUnit.start()
defmodule Testing do
  use ExUnit.Case, async: true

  test "geometric_mean" do
    crabs = [16,1,2,0,4,2,7,1,2,14]
    assert Crabs.find_total_distance_to_geometric_mean(crabs) == 37
  end

  test "MORE FUEL" do
    crabs = [16,1,2,0,4,2,7,1,2,14]
    assert Crabs.find_total_distance_expensive_fuel(crabs) == 168
  end
end
