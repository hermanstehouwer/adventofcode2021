defmodule Origami do

  def input_to_paper_reducer([x, y], acc) do
    acc ++ [{String.to_integer(x),String.to_integer(y)}]
  end

  def input_to_paper(input) do
    Enum.map(input, fn x -> String.split(x, ",", trim: true) end)
    |> Enum.reduce([], &input_to_paper_reducer/2)
  end

  defp fold_num(a, x) do
    if a < x do
      a
    else
      x - (a - x)
    end
  end

  defp process_instruction(instruction_list, coordinates)

  defp process_instruction(["fold along x", x], coordinates) do
    Enum.map(coordinates, fn {a, b} -> {fold_num(a,x) ,b} end)
  end

  defp process_instruction(["fold along y", y], coordinates) do
    Enum.map(coordinates, fn {a, b} -> {a, fold_num(b,y)} end)
  end

  def process_instruction_reducer(instruction, coordinates) do
    [instr, a] = String.split(instruction, "=", trim: true)
    process_instruction([instr, String.to_integer(a)], coordinates) |> Enum.uniq()
  end

  def find_maxxes(coordinates) do
    [
      Enum.max(Enum.map(coordinates, fn {x, _y} -> x end)),
      Enum.max(Enum.map(coordinates, fn {_x, y} -> y end))
    ]
  end
end
