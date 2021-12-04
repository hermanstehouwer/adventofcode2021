defmodule Day4 do
  def setup(find_last) do
    [num|c] = AOC_input.get_day_simple(4, trim: true) |> Enum.filter(fn x -> x != "" end)
    numbers = num |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    cards = c |> Enum.chunk_every(5) |> Enum.map(&BingoCard.init/1)
    %BingoGame{cards: cards, find_last: find_last, numbers: numbers}
  end

  def setup_and_play(find_last) do
    game = setup(find_last)
    BingoGame.run_game(game)
  end

  def part1 do
    setup_and_play(false)
  end

  def part2 do
    setup_and_play(true)
  end
end

IO.inspect(Day4.part1())
IO.inspect(Day4.part2())
