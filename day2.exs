defmodule DAY2 do
  def follow_course(instructions, do_aim \\ false, position \\ {0,0,0})

  def follow_course(instructions, _do_aim, position) when [] == instructions do
    position
  end

  def follow_course([hd|tl], do_aim, {pos, depth, aim}) when do_aim do
    case hd do
      {"forward", amount} ->
        follow_course(tl, do_aim, {pos+amount, depth+aim*amount, aim})
      {"down", amount} ->
        follow_course(tl, do_aim, {pos, depth, aim+amount})
      {"up", amount} ->
        follow_course(tl, do_aim, {pos, depth, aim-amount})
    end
  end

  def follow_course([hd|tl], do_aim, {pos, depth, aim}) do
    case hd do
      {"forward", amount} ->
        follow_course(tl, do_aim, {pos+amount, depth, aim})
      {"down", amount} ->
        follow_course(tl, do_aim, {pos, depth+amount, aim})
      {"up", amount} ->
        follow_course(tl, do_aim, {pos, depth-amount, aim})
    end
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
