oct0 = %Octopus{octopi: AOC_input.get_day_coord_map_ints(11)}

octopus = Octopus.step(oct0, 100)
IO.inspect octopus.flashes
IO.inspect octopus.steps

octopus = Octopus.step(oct0, -1, true)
IO.inspect octopus.steps
