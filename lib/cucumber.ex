defmodule Cucumber do
  defstruct map: %{},
            steps: 0,
            max: {0,0},
            old_map: %{}

  def init(map) do
    new_map = Map.to_list(map)
    |> Enum.filter(fn {_x,y} -> y == "v" or y == ">" end)
    |> Map.new()
    max_x = Map.keys(map) |> Enum.map(&(elem(&1,0))) |> Enum.max()
    max_y = Map.keys(map) |> Enum.map(&(elem(&1,1))) |> Enum.max()
    %Cucumber{map: new_map, max: {max_x, max_y}}
  end

  def same?(cucumber), do: cucumber.map == cucumber.old_map

  def get_tgt({{x,y}, ">"}, {max_x, _}), do: { rem( x+1 , (max_x) +1 ) , y}
  def get_tgt({{x,y}, "v"}, {_, max_y}), do: {x, rem(y+1, (max_y) +1)}

  def movable?(to_move, cucumber), do: !Map.has_key?(cucumber.map, get_tgt(to_move, cucumber.max))

  def move([], map, _), do: map
  def move([hd|tl], map, cucumber) do
    {old_key, arrow} = hd
    tgt = get_tgt(hd, cucumber.max)
    move(tl, Map.put(Map.delete(map, old_key), tgt, arrow), cucumber)
  end

  def step_herd(cucumber, herd) do
    to_move = Map.to_list(cucumber.map)
    |> Enum.filter(fn {_x,y} -> y == herd end)
    |> Enum.filter(&(movable?(&1, cucumber)))
    %{cucumber | map: move(to_move, cucumber.map, cucumber)}
  end

  def step(cucumber) do
    cucumber = %{cucumber | old_map: cucumber.map}
    cucumber = step_herd(cucumber, ">")
    cucumber = step_herd(cucumber, "v")
    %{cucumber | steps: cucumber.steps + 1}
  end

  def stepping(cucumber) do
    if same?(cucumber) do
      cucumber
    else
      stepping(step(cucumber))
    end
  end

  def print(cucumber) do
    {mx, my} = cucumber.max
    for y <- 0..my do
      for x <- 0..mx do
        Map.get(cucumber.map, {x,y}, ".")
      end
      |> Enum.join("") |> IO.inspect()
    end
    cucumber
  end
end
