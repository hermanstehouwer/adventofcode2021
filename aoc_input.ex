defmodule AOC_input do
  defp get_day_simple(day) when is_integer(day) do
    get_day_simple(Integer.to_string(day))
  end

  defp get_day_simple(day) do
    {:ok, contents} = File.read("data/day"<> day <>".txt")
    contents |> String.split("\n", trim: true)
  end

  def get_day_integers(day) do
    get_day_simple(day) |> Enum.map(&String.to_integer/1)
  end

  def word_int_helper(word) do
    [a, b] = String.split(word, " ", trim: true)
    int = String.to_integer(b)
    {a, int}
  end

  def get_day_split_word_int(day) do
    get_day_simple(day) |> Enum.map(&word_int_helper/1)
  end
end
