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

  @spec turns()::[coord()]
  defp turns(), do: [
    [1,2,3], [-2,1,3], [-1,-2,3], [2,-1,3], [1, -3, 2], [3, 1, 2], [-1, 3, 2], [-3, -1, 2],
    [1, 3, -2], [-3, 1, -2], [-3, -1, -2], [-1,-3, -2], [3,-1, -2], [1, -2, -3], [2, 1, -3],
    [-1, 2, -3], [-2, -1, -3], [-3, 2, 1], [-2, -3, 1], [3, -2, 1], [2, 3, 1], [3, 2, -1],
    [-2, 3, -1], [-3,-2,-1],[2,-3,-1]]

  @spec rot(coord(), coord())::coord()
  defp rot(coord, [a,b,c]), do: [
    Enum.at(coord, abs(a)-1) * div(a, abs(a)),
    Enum.at(coord, abs(b)-1) * div(b, abs(b)),
    Enum.at(coord, abs(c)-1) * div(c, abs(c))]

  @spec rotate(Scanner.t(), coord())::Scanner.t()
  def rotate(scanner, rotation), do: %Scanner{coords: Enum.map(scanner.coords, &(rot(&1, rotation))), rotation: rotation}

  @spec rotations(Scanner.t())::[Scanner.t()]
  def rotations(scanner), do: Enum.map(turns(), &(rotate(scanner, &1)) )

  def dist([x1, x2, x3], [y1, y2, y3]), do: [x1-y1, x2-y2, x3-y3]
  def  mov([x1, x2, x3], [y1, y2, y3]), do: [x1+y1, x2+y2, x3+y3]

  def aligned(s, tf) do
    shifts = for a <- s.coords, b <- tf.coords, do: dist(a, b)
    {most, freq} = Enum.frequencies(shifts) |> Enum.max_by(&(elem(&1,1)))
    if freq >= 12, do: most, else: nil
  end

  def fits(aligned, to_fit) do
    for tf <- Scanner.rotations(to_fit) do
      for s <- aligned do
        {aligned(s, tf), tf.rotation}
      end
    end
    |> List.flatten()
    |> Enum.filter( &( !is_nil(elem(&1,0)) ) )
    |> List.first()
  end

  def find_fit(aligned, to_fit)

  def find_fit(_aligned, []), do: nil

  def find_fit(aligned, [hd|tl]) do
    fit = fits(aligned, hd)
    case fit do
      nil -> find_fit(aligned, tl)
      _ -> {hd, elem(fit, 0), elem(fit, 1)} #fit == {distance, rotation}
    end
  end

  @spec rot_and_mov(Scanner.t(), coord(), coord())::Scanner.t()
  def rot_and_mov(fitting, distance, rotation) do
    %Scanner{
      coords: Enum.map(fitting.coords, &( mov(rot(&1, rotation), distance) )),
      offset: distance,
      rotation: rotation
    }
  end

  @spec reconstruct([Scanner.t()], [Scanner.t()])::[Scanner.t()]
  def reconstruct(aligned, []), do: aligned
  def reconstruct(aligned, to_align) do
    {fitting, distance, rotation} = find_fit(aligned, to_align)
    to_align = to_align -- [fitting]
    aligned = [rot_and_mov(fitting, distance, rotation) |aligned]
    reconstruct(aligned, to_align)
  end

  @spec reconstruct([Scanner.t()])::[Scanner.t()]
  def reconstruct([start|rest]), do: reconstruct([start], rest)

  def reduce_scanners(scanner, acc), do: acc ++ scanner.coords

  def manhattan([a1,a2,a3], [b1, b2, b3]), do: abs(a1 - b1) + abs(a2 - b2) + abs(a3 - b3)
  def manhattan(%Scanner{offset: a}, %Scanner{offset: b}), do: manhattan(a,b)
end
