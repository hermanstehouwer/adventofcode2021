defmodule Polymer do

  def input_to_rules_reducer([a, b], acc) do
    [x,y] = String.split(a, "", trim: true)
    Map.put(acc, {x,y}, [{x,b}, {b,y}])
  end

  def input_to_rules(input) do
    Enum.map(input, fn x -> String.split(x, " -> ", trim: true) end)
    |> Enum.reduce(%{}, &input_to_rules_reducer/2)
  end

  def apply_reducer({tomatch, count}, acc, rules) do
    [a, b] = rules[tomatch]
    Map.update(acc, a, count, &(&1 + count))
    |> Map.update(b, count, &(&1 + count))
  end

  def apply_rules(rules, input, times)

  def apply_rules(_rules, input, 0) do
    input
  end

  def apply_rules(rules, input, times) do
    output = Enum.reduce(input, %{}, fn tomatch, acc -> apply_reducer(tomatch, acc, rules) end)
    apply_rules(rules, output, times-1)
  end

  def score(input, to_add_one_to) do
    fre = Map.to_list(input) |> Enum.map(fn {{x,y}, z} -> [{x, z}] end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn {a, z}, acc -> Map.update(acc, a, z, &(&1 + z)) end)
    freq = Map.update(fre, to_add_one_to, 1, &(&1 +1))
    |> Enum.map(fn {_x,y} -> y end)
    Enum.max(freq) - Enum.min(freq)
  end
end
