defmodule DAY2 do
  #instruction: {action, amount}
  #position: {pos, depth, aim, do_aim}
  def follow_course(instructions, position)

  #Part 1 (do_aim: false)
  def follow_course({"forward", amount}, {pos, depth, aim, false}) do
    {pos+amount, depth, aim, false}
  end

  def follow_course({"up", amount}, {pos, depth, aim, false}) do
    {pos, depth-amount, aim, false}
  end

  def follow_course({"down", amount}, {pos, depth, aim, false}) do
    {pos, depth+amount, aim, false}
  end

  #Part 2 (do_aim: true)
  def follow_course({"forward", amount}, {pos, depth, aim, true}) do
    {pos+amount, depth+aim*amount, aim, true}
  end

  def follow_course({"up", amount}, {pos, depth, aim, true}) do
    {pos, depth, aim-amount, true}
  end

  def follow_course({"down", amount}, {pos, depth, aim, true}) do
    {pos, depth, aim+amount, true}
  end
end

input = AOC_input.get_day_split_word_int(2)
{pos, depth, _aim, _do_aim} = input |> Enum.reduce({0,0,0,false}, &DAY2.follow_course/2)
IO.puts(pos*depth)

#part2
{pos, depth, _aim, _do_aim} = input |> Enum.reduce({0,0,0,true}, &DAY2.follow_course/2)
IO.puts(pos*depth)
