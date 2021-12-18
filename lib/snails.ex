defmodule Snails do

  def snail_reduce(snail_num) do
    {exploded, snail_num, _la, _ra} = snail_explode(snail_num, 0)
    if exploded do
      snail_reduce(snail_num)
    else
      {split, snail_num} = snail_split(snail_num)
      if split do
        snail_reduce(snail_num)
      else
        snail_num
      end
    end
  end

  def adder([l, r], to_add, :right), do: [adder(l, to_add, :right), r]
  def adder([l, r], to_add, :left), do: [l, adder(r, to_add, :left)]
  def adder(x, to_add, _), do: x + to_add


  # try to explode and return {true, snail_num, left_add, right_add} if so, {false, snail_num, la, ra} otherwise
  def snail_explode(snail_num, depth)

  def snail_explode([a,b], 4) do
    {true, 0, a, b}
  end

  def snail_explode([a,b], depth) do
    #EXPLODE Left
    {exploded, snail_num, left_add, right_add} = snail_explode(a, depth+1)
    if exploded do
      # add to left, add to right
      #completely on the left side the left-add will disappear.
      {true, [snail_num, adder(b, right_add, :right)], left_add, 0}
    else
      #EXPLODE right
      {exploded, snail_num, left_add, right_add} = snail_explode(b, depth+1)
      if exploded do
          {exploded, [adder(a, left_add, :left), snail_num], 0, right_add}
      else
        {false, [a,b], left_add, right_add}
      end
    end
  end

  def snail_explode(item, depth) do
    {false, item, 0, 0}
  end

  # try to split and return {true, snail_num} if so, {false, snail_num} otherwise
  def snail_split(snail_num)

  def snail_split([a,b]) do
    {split, a} = snail_split(a)
    if split do
      {true, [a,b]}
    else
      {split, b} = snail_split(b)
      if split do
        {true, [a,b]}
      else
        {false, [a,b]}
      end
    end
  end

  def snail_split(x) when x < 10, do: {false, x}
  def snail_split(x), do: {true, [floor(x/2),ceil(x/2)]}

  def snail_add(elem,acc) do
    snail_reduce([acc,elem])
  end

  def magnitude([a, b]), do: 3*magnitude(a) + 2*magnitude(b)
  def magnitude(a), do: a
end
