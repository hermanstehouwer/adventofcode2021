defmodule DAY2 do
  def follow_course(instructions, do_aim \\ false, position \\ {0,0,0})

  def follow_course([], _do_aim, position) do
    position
  end

  def follow_course([{"forward", amount}|tl], true, {pos, depth, aim}) do
    follow_course(tl, true, {pos+amount, depth+aim*amount, aim})
  end

  def follow_course([{"forward", amount}|tl], false, {pos, depth, aim}) do
    follow_course(tl, false, {pos+amount, depth, aim})
  end

  def follow_course([{"down", amount}|tl], true, {pos, depth, aim}) do
    follow_course(tl, true, {pos, depth, aim+amount})
  end

  def follow_course([{"down", amount}|tl], false, {pos, depth, aim}) do
    follow_course(tl, false, {pos, depth+amount, aim})
  end

  def follow_course([{"up", amount}|tl], true, {pos, depth, aim}) do
    follow_course(tl, true, {pos, depth, aim-amount})
  end

  def follow_course([{"up", amount}|tl], false, {pos, depth, aim}) do
    follow_course(tl, false, {pos, depth-amount, aim})
  end
end

#part1
input = AOC_input.get_day_split_word_int(2)
{pos, depth, _aim} = DAY2.follow_course(input)
IO.puts(pos*depth)

#part2
input = AOC_input.get_day_split_word_int(2)
{pos, depth, _aim} = DAY2.follow_course(input, true)
IO.puts(pos*depth)
