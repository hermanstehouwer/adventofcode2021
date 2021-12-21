defmodule Player do
  defstruct pos: 0,
            score: 0
end

defmodule Dirac do

  def roll(die, sum\\0, rolls\\3)
  def roll(die, sum, 0), do: {die, sum}
  def roll(101, sum, roll), do: roll(1, sum, roll)
  def roll(die, sum, roll), do: roll(die+1, sum+die, roll-1)

  def play_rounds(player1, player2, turns, die)
  def play_rounds(%Player{score: score1}, %Player{score: score2}, turns, _) when score1 > 999, do: turns * 3 * score2
  def play_rounds(%Player{score: score1}, %Player{score: score2}, turns, _) when score2 > 999, do: turns * 3 * score1
  def play_rounds(p1,p2, turns, die) when rem(turns, 2) == 0 do
    {die, roll} = roll(die)
    newpos = rem((p1.pos + roll - 1), 10)+1
    play_rounds(%Player{pos: newpos, score: p1.score + newpos}, p2, turns+1, die)
  end
  def play_rounds(p1,p2, turns, die) do
    {die, roll} = roll(die)
    newpos = rem((p2.pos + roll - 1), 10)+1
    play_rounds(p1, %Player{pos: newpos, score: p2.score + newpos}, turns+1, die)
  end

  def play_game(p1_start, p2_start) do
    play_rounds(
      %Player{pos: p1_start},
      %Player{pos: p2_start},
      0,
      1
    )
  end
end

#part1:
IO.inspect( Dirac.play_game(1,6) )
