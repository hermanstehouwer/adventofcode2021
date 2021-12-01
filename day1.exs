defmodule DAY1 do
  def count_up(rest, prev \\ nil, acc \\ nil)

  def count_up([hd|tl], prev, _acc) when is_nil(prev) do
    count_up(tl, hd, 0)
  end

  def count_up(rest, _prev, acc) when rest == [] do
    acc
  end

  def count_up([hd|tl], prev, acc) when hd > prev do
    count_up(tl, hd, acc+1)
  end

  def count_up([hd|tl], _prev, acc) do
    count_up(tl, hd, acc)
  end
end

content = AOC_input.get_day_integers(1)
part1 = DAY1.count_up(content)
IO.puts(part1)

second = content |> Enum.chunk_every(3, 1, :discard) |> Enum.map(&Enum.sum/1)
part2 = DAY1.count_up(second)
IO.puts(part2)
