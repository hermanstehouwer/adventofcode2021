defmodule Segments do
  defstruct decoder: %{},
            encoder: %{},
            output: 0

  @type t :: %__MODULE__{
    decoder: %{MapSet.t() => integer()},
    encoder: %{integer() => MapSet.t()},
    output: integer()
   }

  @spec t_m2(String.t())::[MapSet.t]
  defp t_m2(input) do
    String.split(input)
    |> Enum.map(fn x -> String.split(x, "", trim: true) end)
    |> Enum.map(&MapSet.new/1)
  end

  @spec to_mapsets(String.t())::{[MapSet.t()],[MapSet.t()]}
  defp to_mapsets(inputline) do
    [input, output] = String.split(inputline, " | ", trim: true)
    {t_m2(input), t_m2(output)}
  end

  defp f_and_s_reducer({target, filter_fun}, {segments, input}) do
    [wires] = Enum.filter(input, fn x -> filter_fun.(x, segments) end)
    output = input -- [wires]
    dec = Map.put(segments.decoder, wires, target)
    enc = Map.put(segments.encoder, target, wires)
    {%{segments | decoder: dec, encoder: enc}, output}
  end

  @spec find_and_set(Segments.t(), [MapSet.t()])::Segments.t()
  defp find_and_set(segments, input) do
    [
      {1, fn x, _s -> MapSet.size(x) == 2 end},
      {4, fn x, _s -> MapSet.size(x) == 4 end},
      {7, fn x, _s -> MapSet.size(x) == 3 end},
      {8, fn x, _s -> MapSet.size(x) == 7 end},
      {9, fn x, s -> MapSet.size(x) == 6 and MapSet.subset?(s.encoder[4], x) end},
      {0, fn x, s -> MapSet.size(x) == 6 and MapSet.subset?(s.encoder[1], x) end},
      {6, fn x, _s -> MapSet.size(x) == 6 end},
      {3, fn x, s -> MapSet.size(x) == 5 and MapSet.subset?(s.encoder[1], x) end},
      {5, fn x, s -> MapSet.size(x) == 5 and MapSet.subset?(x, s.encoder[6]) end},
      {2, fn _x, _s -> true end}
    ]
    |> Enum.reduce({segments, input}, &f_and_s_reducer/2)
    |> elem(0)
  end

  defp calculate(_segments, [], _multiplier) do
    0
  end

  defp calculate(segments, [hd|tl], multiplier) do
    segments.decoder[hd] * multiplier + calculate(segments, tl, multiplier*10)
  end

  @spec decode_from_input(String.t())::SEGMENTS.t()
  def decode_from_input(inputline) do
    {input, output} = to_mapsets(inputline)
    segments = find_and_set(%Segments{}, input)
    %{segments | output: calculate(segments, Enum.reverse(output), 1)}
  end
end
