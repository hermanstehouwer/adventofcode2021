defmodule Line do
  defstruct start: Nil,
            end: Nil

  @type point :: {integer(), integer()}
  @type t :: %__MODULE__{
    start: point,
    end: point,
  }

  @spec from_string(String.t())::Line.t()
  def from_string(string) do
    [s,e] = String.split(string, " -> ", trim: true)
    [ss, se] = s |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    [es, ee] = e |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
    %Line{
      start: {ss,se},
      end: {es,ee}
    }
  end

  @spec diagonal_points(integer(),integer(),integer(),integer())::list(point())
  def diagonal_points(a,b,c,d)

  # make sure that a -> c is always adding one.
  def diagonal_points(a,b,c,d) when a > c do
    diagonal_points(c,d,a,b)
  end

  #a < c && b < d -> +{1,1}
  def diagonal_points(a,b,c,d) when c-a == d-b do
    Enum.zip(a..c, b..d)
  end

  #a <c && b > d -> {+1, -1}
  def diagonal_points(a,b,c,d) do
    Enum.zip(a..c, b..d//-1)
  end

  @spec get_points(Line.t(), boolean())::list(point())
  def get_points(line, do_diagonal \\ false)

  def get_points(line, do_diagonal) do
    {a,b} = line.start
    {c,d} = line.end
    cond do
      a == c -> min(b,d)..max(b,d) |> Enum.map(fn x -> {a, x} end)
      b == d -> min(a,c)..max(a,c) |> Enum.map(fn x -> {x, b} end)
      do_diagonal -> diagonal_points(a,b,c,d)
      true -> []
    end
  end
end

defmodule Vents do
  defstruct lines: Nil

  @type point :: {integer(), integer()}
  @type t :: %__MODULE__{
    lines: list(Line.t()),
  }

  @spec from_strings(list(String.t()))::Vents.t()
  def from_strings(strings) do
    lines = strings |> Enum.map(&Line.from_string/1)
    %Vents{lines: lines}
  end

  @spec get_overlap(Vents.t(), boolean())::list(point)
  def get_overlap(vents, do_diagonal \\ false)

  def get_overlap(vents, do_diagonal) do
    all_points = vents.lines |> Enum.map(&(Line.get_points(&1, do_diagonal))) |> List.flatten()
    overlap_points = all_points -- Enum.uniq(all_points)
    Enum.uniq(overlap_points)
  end
end
