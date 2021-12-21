defmodule Day21 do
  use Memoize

  defmemo all_rolls, do: for a <- 1..3, b <- 1..3, c <- 1..3, do: a+b+c
  def new_pos(pos, roll), do: rem((pos + roll - 1), 10)+1

  defmemo play_game(_,{player, _, s}) when s > 20, do: if player == 0, do: {1, 0}, else: {0, 1}

  defmemo play_game({id, pos, score}, p2) do
    for roll <- all_rolls() do
      new_pos = new_pos(pos, roll)
      play_game(p2, {id, new_pos, score+new_pos})
    end
    |> Enum.reduce({0,0}, fn {a1,a2}, {b1,b2} -> {a1+b1, a2+b2} end)
  end

  def part2 do
    {p1_wins, p2_wins} = play_game({0,1,0},{1,6,0})
    IO.inspect( Enum.max([p1_wins, p2_wins]))
  end
end
