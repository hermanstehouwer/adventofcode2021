start_image = AOC_input.get_day_double(20) |> Enhance.from_input()
stepped = Enhance.steps(start_image, 2)
IO.inspect length(Map.keys(stepped.image))

stepped = Enhance.steps(start_image, 50)
IO.inspect length(Map.keys(stepped.image))
