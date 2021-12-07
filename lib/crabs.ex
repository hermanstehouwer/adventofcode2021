defmodule Crabs do
  def triangle_number(x)

  def triangle_number(0) do 0 end
  def triangle_number(1) do 1 end
  def triangle_number(x) do
    1..x |> Enum.sum()
  end


  def fuel_to_x(crabs, x) do
    Enum.map(crabs, fn y -> triangle_number(abs(x - y)) end)
    |> Enum.sum()
  end

  def total_distance_to_x(crabs, x) do
    Enum.map(crabs, fn y -> abs(x - y) end)
    |> Enum.sum()
  end

  def find_total_distance_to_geometric_mean(crabs) do
    {min,max} = Enum.min_max(crabs)
    min..max |>
    Enum.map(fn x -> total_distance_to_x(crabs, x) end)
    |> Enum.min()
  end

  def find_total_distance_expensive_fuel(crabs) do
    {min,max} = Enum.min_max(crabs)
    min..max |>
    Enum.map(fn x -> fuel_to_x(crabs, x) end)
    |> Enum.min()
  end
end
