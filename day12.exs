AOC_input.get_day_simple(12, true)
|> Passages.input_to_graph()
|> Passages.find_all_paths(["start"])
|> length()
|> IO.inspect()

AOC_input.get_day_simple(12, true)
|> Passages.input_to_graph()
|> Passages.find_all_paths(["start"], true)
|> length()
|> IO.inspect()
