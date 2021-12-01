defmodule DAY1 do
  def next_higher(pair)

  def next_higher([hd|[tl|_x]]) when tl > hd do
    1
  end

  def next_higher(_pair) do
    0
  end
end

#part1
AOC_input.get_day_integers(1)
|> Enum.chunk_every(2, 1, :discard)
|> Enum.map(&DAY1.next_higher/1)
|> Enum.sum()
|> IO.puts()

#part2
AOC_input.get_day_integers(1)
|> Enum.chunk_every(3, 1, :discard)
|> Enum.map(&Enum.sum/1)
|> Enum.chunk_every(2, 1, :discard)
|> Enum.map(&DAY1.next_higher/1)
|> Enum.sum()
|> IO.puts()
