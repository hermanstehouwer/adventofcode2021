defmodule Enhance do
  defstruct enhancement: %{},
            image: %{},
            out_of_bounds_value: "0"

  def to_pxls({"#", loc}), do: {loc, "1"}
  def to_pxls({".", _}), do: nil
  def to_pxls([]), do: []
  def to_pxls([hd|tl]), do: [to_pxls(hd)] ++ to_pxls(tl)
  def to_pxls1(x), do: String.graphemes(x) |> Enum.zip(0..9999) |> to_pxls() |> Enum.filter(&(!is_nil(&1)))
  def from_input([[enhancement], image]) do
    enhancement = to_pxls1(enhancement) |> Map.new()

    image = for y <- 0..(length(image) -1) do
      Enum.at(image, y)
      |> to_pxls1()
      |> Enum.map(&({{elem(&1,0), y},1}))
    end
    |> List.flatten()
    |> Map.new()
    oobf = if 0 in Map.keys(enhancement), do: "0", else: nil
    %Enhance{enhancement: enhancement, image: image, out_of_bounds_value: oobf}
  end

  def get_bounds(enhance) do
    { (Map.keys(enhance.image) |> Enum.map(&(elem(&1,0))) |> Enum.min()),
      (Map.keys(enhance.image) |> Enum.map(&(elem(&1,1))) |> Enum.min()),
      (Map.keys(enhance.image) |> Enum.map(&(elem(&1,0))) |> Enum.max()),
      (Map.keys(enhance.image) |> Enum.map(&(elem(&1,1))) |> Enum.max())}
  end

  def get_locations({x,y}) do
    [[-1,-1],[0,-1],[1,-1],
     [-1,0],[0,0],[1,0],
     [-1,1],[0,1],[1,1]]
     |> Enum.map(fn [a,b] -> {x+a, y+b} end)
  end

  def in_bounds?({x,y}, {min_x, min_y, max_x, max_y}), do: x >= min_x and x <= max_x and y >= min_y and y <= max_y

  def get_bit(enhance, coord, bounds) do
    if in_bounds?(coord, bounds) do
      Map.get(enhance.image, coord, "0")
    else
      if is_nil(enhance.out_of_bounds_value), do: "0", else: enhance.out_of_bounds_value
    end
  end

  def get_new_value(enhance, coord, bounds) do
    lookup = get_locations(coord)
    |> Enum.map(&(get_bit(enhance, &1, bounds)))
    |> Enum.join("")
    |> String.to_integer(2)
    if lookup in Map.keys(enhance.enhancement) do
      {coord, "1"}
    else
      nil
    end
  end

  def new_oobf(x) when is_nil(x), do: nil
  def new_oobf("0"), do: "1"
  def new_oobf("1"), do: "0"


  def step(enhance) do
    bounds = get_bounds(enhance)
    {min_x, min_y, max_x, max_y} = bounds
    new_image = for x <- min_x-1..max_x+1 do
      for y <- min_y-1..max_y+1 do
        get_new_value(enhance, {x, y}, bounds)
      end
    end
    |> List.flatten()
    |> Enum.filter(&(!is_nil(&1)))
    |> Map.new()
    %{enhance | image: new_image, out_of_bounds_value: new_oobf(enhance.out_of_bounds_value)}
  end

  def steps(enhance, 0), do: enhance
  def steps(enhance, num), do: steps(step(enhance), num-1)
end
