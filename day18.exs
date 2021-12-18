

#Read in and parse the lists of lists of lists of lists.
#Yes, am lazy :)
numbers = AOC_input.get_day_simple(18)
|> Enum.map(fn x -> Code.eval_string(x) |> elem(0) end)

# part1
Enum.reduce(numbers, &Snails.snail_add/2)
|> Snails.magnitude()
|> IO.inspect()

# part2
for x <- numbers do
  for y <- numbers do
    if x == y do
      0
    else
      Snails.snail_add(y,x) |> Snails.magnitude()
    end
  end
end
|>List.flatten()
|> Enum.max()
|> IO.inspect()
