defmodule DAY1 do
  def next_higher(pair)

  def next_higher([hd|[tl|_x]]) do
    cond do
      tl > hd -> 1
      true -> 0
    end
  end
end

content = AOC_input.get_day_integers(1)

#part1
content
|> Enum.chunk_every(2, 1, :discard)
|> Enum.map(&DAY1.next_higher/1)
|> Enum.sum()
|> IO.puts()

#part2
content
|> Enum.chunk_every(3, 1, :discard)
|> Enum.map(&Enum.sum/1)
|> Enum.chunk_every(2, 1, :discard)
|> Enum.map(&DAY1.next_higher/1)
|> Enum.sum()
|> IO.puts()
