defmodule Passages do
  @type graph::%{String.t() => [String.t()]}
  @type path::String.t()

  def input_to_graph_reducer([e1, e2], acc) do
    acc
    |> Map.update(e1, [e2], fn x -> x ++ [e2] end)
    |> Map.update(e2, [e1], fn x -> x ++ [e1] end)
  end

  @spec input_to_graph([String.t()])::graph()
  def input_to_graph(input) do
    Enum.map(input, fn x -> String.split(x, "-", trim: true) end)
    |> Enum.reduce(%{}, &input_to_graph_reducer/2)
  end

  defp downcase?(input), do: input == String.downcase(input)

  defp get_filter(list, twice)
  defp get_filter(list, false) do
    {Enum.filter(list, &downcase?/1), false}
  end

  defp get_filter(list, true) do
    {filter_a, false} = get_filter(list, false)
    filter_b = filter_a -- Enum.uniq(filter_a)
    if length(filter_b) > 0 do
      # We already have a lowercased cave that we visited twice. So back to regular filtering
      {filter_a, false}
    else
      {["start"], true} # We are not allowed to visit "start" twice
    end
  end

  @spec find_all_paths(graph(), [String.t()], boolean())::[path()]
  def find_all_paths(graph, partial_path, twice \\ false)

  def find_all_paths(_graph, ["end"|tl], _twice) do
    [Enum.join(["end"|tl], "-")]
  end

  def find_all_paths(graph, [hd|tl], twice) do
    {filter, newtwice} = get_filter([hd|tl], twice)
    graph[hd] |> Enum.filter(fn x -> !(x in filter) end)
    |> Enum.map(fn x -> find_all_paths(graph, [x|[hd|tl]], newtwice) end)
    |> List.flatten()
  end
end
