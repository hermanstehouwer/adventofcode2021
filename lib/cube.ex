defmodule Cube do
  defstruct bounds: {0,0,0,0,0,0}, #x1..x2, y1..y2, z1..z2
            children: [],
            off: false
  @type t :: %__MODULE__{
    bounds: {integer(),integer(),integer(),integer(),integer(),integer()},
    children: [Cube.t()],
    off: boolean()
  }

  def sub_x_1({x1, x2, y1, y2, z1, z2}, {a1, _a2, _b1, _b2, _c1, _c2}) when x1 < a1 do
    {%Cube{bounds: {x1,a1, y1,y2, z1,z2}}, {a1, x2, y1, y2, z1, z2}}
  end
  def sub_x_1({x1, x2, y1, y2, z1, z2}, _) do
    {nil, {x1, x2, y1, y2, z1, z2}}
  end

  def sub_y_1({x1, x2, y1, y2, z1, z2}, {_a1, _a2, b1, _b2, _c1, _c2}) when y1 < b1 do
    {%Cube{bounds: {x1,x2, y1,b1, z1,z2}}, {x1, x2, b1, y2, z1, z2}}
  end
  def sub_y_1({x1, x2, y1, y2, z1, z2}, _) do
    {nil, {x1, x2, y1, y2, z1, z2}}
  end

  def sub_z_1({x1, x2, y1, y2, z1, z2}, {_a1, _a2, _b1, _b2, c1, _c2}) when z1 < c1 do
    {%Cube{bounds: {x1,x2, y1,y2, z1, c1}}, {x1, x2, y1, y2, c1, z2}}
  end
  def sub_z_1({x1, x2, y1, y2, z1, z2}, _) do
    {nil, {x1, x2, y1, y2, z1, z2}}
  end


  def sub_x_2({x1, x2, y1, y2, z1, z2}, {_a1, a2, _b1, _b2, _c1, _c2}) when x2 > a2 do
    {%Cube{bounds: {a2,x2, y1,y2, z1,z2}}, {x1, a2, y1, y2, z1, z2}}
  end

  def sub_x_2({x1, x2, y1, y2, z1, z2}, _) do
    {nil, {x1, x2, y1, y2, z1, z2}}
  end


  def sub_y_2({x1, x2, y1, y2, z1, z2}, {_a1, _a2, _b1, b2, _c1, _c2}) when y2 > b2 do
    {%Cube{bounds: {x1,x2, b2,y2, z1,z2}}, {x1, x2, y1, b2, z1, z2}}
  end

  def sub_y_2({x1, x2, y1, y2, z1, z2}, _) do
    {nil, {x1, x2, y1, y2, z1, z2}}
  end

  def sub_z_2({x1, x2, y1, y2, z1, z2}, {_a1, _a2, _b1, _b2, _c1, c2}) when z2 > c2 do
    {%Cube{bounds: {x1,x2, y1,y2,c2,z2}}, {x1, x2, y1, y2, z1, c2}}
  end

  def sub_z_2({x1, x2, y1, y2, z1, z2}, _) do
    {nil, {x1, x2, y1, y2, z1, z2}}
  end

  @spec substract(Cube.t(),Cube.t)::Cube.t()
  def substract(cube1, cube2)

  def substract(#No overlap ...
    %Cube{bounds: {x1, x2, y1, y2, z1, z2}} = cube,
    %Cube{bounds: {a1, a2, b1, b2, c1, c2}}) when
        x1 > a2 or x2 < a1
     or y1 > b2 or y2 < b1
     or z1 > c2 or z2 < c1 do
      cube
  end

  def substract(#cube2 is bigger than cube1
    %Cube{bounds: {x1, x2, y1, y2, z1, z2}},
    %Cube{bounds: {a1, a2, b1, b2, c1, c2}}) when
        x1 >= a1 and x2 <= a2
    and y1 >= b1 and y2 <= b2
    and z1 >= c1 and z2 <= c2 do
      nil
  end

  # not split up yet
  def substract(%Cube{children: []} = cube, cube2) do
      bounds = cube.bounds

      {nc, bounds} = sub_x_1(bounds, cube2.bounds)
      children = [nc]
      {nc, bounds} = sub_x_2(bounds, cube2.bounds)
      children = [nc|children]
      {nc, bounds} = sub_y_1(bounds, cube2.bounds)
      children = [nc|children]
      {nc, bounds} = sub_y_2(bounds, cube2.bounds)
      children = [nc|children]
      {nc, bounds} = sub_z_1(bounds, cube2.bounds)
      children = [nc|children]
      {nc, _bounds} = sub_z_2(bounds, cube2.bounds)
      children = [nc|children]

      children = Enum.filter(children, &(! is_nil(&1)))
      %{cube | children: children}
  end

  def substract(cube, cube2) do #already split up: maybe the kids can split
    new_c = Enum.map(cube.children, &(substract(&1, cube2))) |>Enum.filter(&(! is_nil(&1)))
    if new_c == [] do #If we already had children, but not anymore, clearly we should be empty
      nil
    else
      %{cube | children: new_c}
    end
  end

  def from_string(string) do
    [_, turn_off | coords] = Regex.run(~r/(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/, string)
    {x1,x2,y1,y2,z1,z2} = List.to_tuple(Enum.map(coords, &String.to_integer/1))
    %Cube{
      bounds: {x1,x2+1,y1,y2+1,z1,z2+1},
      off: turn_off == "off"
    }
  end

  def lit(cube)
  def lit(%Cube{bounds: {x1,x2,y1,y2,z1,z2}, children: []}), do: (x2 - x1) * (y2 - y1) * (z2 - z1)
  def lit(%Cube{children: children}), do: Enum.sum(Enum.map(children, &lit/1))

  def reduce(cube, cubes)
  def reduce(cube, []), do: [cube]
  def reduce(cube = %Cube{off: true}, cubes) do
    Enum.map(cubes, fn x -> Cube.substract(x, cube) end) |>Enum.filter(&(! is_nil(&1)))
  end
  def reduce(cube, cubes) do
    [cube | Enum.map(cubes, fn x -> Cube.substract(x, cube) end) |>Enum.filter(&(! is_nil(&1)))]
  end
end
