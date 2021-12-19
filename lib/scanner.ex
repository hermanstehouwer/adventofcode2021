defmodule Scanner do
  defstruct coords: [],
            offset: [0,0,0],
            rotation: [1,2,3]

  @type coord::[integer()]
  @type t :: %__MODULE__{
    coords:   [coord()],
    offset:   coord(),
    rotation: coord()
  }

  def split_n_toi(x), do: String.split(x, ",", trim: true) |> Enum.map(&String.to_integer/1)
  def from_strings([_label | coords]), do: %Scanner{coords: Enum.map(coords, &split_n_toi/1)}

  defp directions(), do: [[1,2,3], [-2,1,3], [-1,-2,3], [2,-1,3], [1, -3, 2], [3, 1, 2], [-1, 3, 2], [-3, -1, 2],
    [1, 3, -2], [-3, 1, -2], [-3, -1, -2], [-1,-3, -2], [3,-1, -2], [1, -2, -3], [2, 1, -3],[-2, 3, -1],
    [-1, 2, -3], [-2, -1, -3], [-3, 2, 1], [-2, -3, 1], [3, -2, 1], [2, 3, 1], [3, 2, -1],[-3,-2,-1],[2,-3,-1]]

  def rotate(%Scanner{coords: coords}, rotation), do: %Scanner{coords: Enum.map(coords, &(rotate(&1, rotation))), rotation: rotation}
  def rotate(coord, [a,b,c]), do: [rotate(coord, a), rotate(coord, b), rotate(coord, c)]
  def rotate(coord, a), do: Enum.at(coord, abs(a)-1) * div(a, abs(a))

  @spec rotations(Scanner.t())::[Scanner.t()]
  def rotations(scanner), do: Enum.map(directions(), &(rotate(scanner, &1)) )

  def dist([x1, x2, x3], [y1, y2, y3]), do: [x1-y1, x2-y2, x3-y3]
  def  mov([x1, x2, x3], [y1, y2, y3]), do: [x1+y1, x2+y2, x3+y3]

  def find_alignment(s, tf) do
    shifts = for a <- s.coords, b <- tf.coords, do: dist(a, b)
    {most, freq} = Enum.frequencies(shifts) |> Enum.max_by(&(elem(&1,1)))
    if freq >= 12, do: most, else: nil
  end

  def find_fit(aligned, to_fit=%Scanner{}) do
    for tf <- Scanner.rotations(to_fit) do
      for s <- aligned, do: {find_alignment(s, tf), tf.rotation}
    end
    |> List.flatten()
    |> Enum.filter( &( !is_nil(elem(&1,0)) ) )
    |> List.first()
  end

  def find_fit(aligned, [hd|tl]) do
    fit = find_fit(aligned, hd)
    case fit do
      nil -> find_fit(aligned, tl)
      _ -> {hd, elem(fit, 0), elem(fit, 1)} #fit == {distance, rotation}
    end
  end

  def rotate_and_move(fitting, distance, rotation), do: %Scanner{offset: distance, rotation: rotation,
      coords: Enum.map(fitting.coords, &( mov(rotate(&1, rotation), distance) ))}

  @spec reconstruct([Scanner.t()], [Scanner.t()])::[Scanner.t()]
  def reconstruct(aligned, []), do: aligned
  def reconstruct(aligned, to_align) do
    {fitting, distance, rotation} = find_fit(aligned, to_align)
    to_align = to_align -- [fitting]
    aligned = [rotate_and_move(fitting, distance, rotation) |aligned]
    reconstruct(aligned, to_align)
  end

  @spec reconstruct([Scanner.t()])::[Scanner.t()]
  def reconstruct([start|rest]), do: reconstruct([start], rest)

  def reduce_scanners(scanner, acc), do: acc ++ scanner.coords

  def manhattan([a1,a2,a3], [b1, b2, b3]), do: abs(a1 - b1) + abs(a2 - b2) + abs(a3 - b3)
  def manhattan(%Scanner{offset: a}, %Scanner{offset: b}), do: manhattan(a,b)
end
