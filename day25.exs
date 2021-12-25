sea_floor = AOC_input.get_day_coord_map_chars(25)
|> Cucumber.init()

#part1
p1 = Cucumber.stepping(sea_floor)
IO.inspect(p1.steps)
