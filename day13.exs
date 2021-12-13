[part1, [hd|tl]] = AOC_input.get_day_double(13)
paper = Origami.input_to_paper(part1)

#Part1
processed = Enum.reduce([hd], paper, &Origami.process_instruction_reducer/2)
IO.inspect length(processed)

#part2
processed = Enum.reduce([hd|tl], paper, &Origami.process_instruction_reducer/2)
[max_x, max_y] = Origami.find_maxxes(processed)

for y <- 0..max_y do
  for x <- 0..max_x do
    if {x,y} in processed do
      "#"
    else
      "."
    end
  end
  |> Enum.join()
  |> IO.inspect()
end
