defmodule AOC_input do
  def get_day_simple(day, trim \\ true)

  def get_day_simple(day, trim) when is_integer(day) do
    get_day_simple(Integer.to_string(day), trim)
  end

  def get_day_simple(day, trim) do
    {:ok, contents} = File.read("data/day"<> day <>".txt")
    contents |> String.split("\n", trim: trim)
  end

  def get_day_integers(day) do
    get_day_simple(day) |> Enum.map(&String.to_integer/1)
  end

  def get_day_all_integers(day) do
    get_day_simple(day)
    |> Enum.join()
    |> String.split(",", trim: true)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  def word_int_helper(word) do
    [a, b] = String.split(word, " ", trim: true)
    int = String.to_integer(b)
    {a, int}
  end

  def get_day_split_word_int(day) do
    get_day_simple(day) |> Enum.map(&word_int_helper/1)
  end

  def full_split_helper(word) do
    String.split(word, "", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def get_day_char_split_int(day) do
    get_day_simple(day) |> Enum.map(&full_split_helper/1)
  end
end
