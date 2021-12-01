defmodule AOC_input do
  defp get_day_simple(day) when is_integer(day) do
    get_day_simple(Integer.to_string(day))
  end

  defp get_day_simple(day) do
    {:ok, contents} = File.read("data/day"<> day <>".txt")
    contents |> String.split("\n", trim: true)
  end

  def get_day_integers(day) do
    Enum.map(get_day_simple(day), &String.to_integer/1)
  end
end
