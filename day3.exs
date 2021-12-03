defmodule DAY3 do
  @type binary_number :: list(integer)
  @type numlist :: list(integer)


  @spec binary_number_to_int(binary_number)::integer
  def binary_number_to_int(number) do Enum.map(number, &Integer.to_string/1) |> Enum.join("") |> String.to_integer(2) end


  @spec reducer(binary_number, numlist) :: numlist()
  def reducer(to_add, acc)

  def reducer(to_add, acc) do
    to_add |> Enum.zip(acc)  |> Enum.map(& (elem(&1, 0) + elem(&1, 1)))
  end


  @spec gamma_and_epsilon(numlist(), integer())::{integer, integer}
  def gamma_and_epsilon(list, cutoff) do
    pre_gamma = Enum.map(list, fn x -> div(x, cutoff) end)
    gamma = binary_number_to_int(pre_gamma)
    epsilon = binary_number_to_int(Enum.map(pre_gamma, fn x -> 1 - x end))
    {gamma, epsilon}
  end


  @spec sum_list(list(binary_number()))::numlist()
  def sum_list(list) do list |> Enum.reduce(List.duplicate(0, 13), &DAY3.reducer/2) end


  @spec apply_filter(list(binary_number()), integer(), integer(), boolean())::list(binary_number())
  def apply_filter(list, index, filter_value, most_common)
  def apply_filter(list, index, filter_value, true) do Enum.filter(list, fn x -> Enum.at(x, index) == filter_value end ) end
  def apply_filter(list, index, filter_value, false) do apply_filter(list, index, 1-filter_value, true) end


  @spec find_rating(list(binary_number), integer, boolean) :: integer
  def find_rating(list, index, most_common)

  def find_rating([item], _index, _most_common) do
    binary_number_to_int(item)
  end

  def find_rating(list, index, most_common) do
    cutoff = div(length(list),  2) + rem(length(list), 2)
    filter_on = div Enum.at(sum_list(list), index), cutoff
    find_rating(apply_filter(list, index, filter_on, most_common), index+1, most_common)
  end
end

input = AOC_input.get_day_char_split_int 3
cutoff = div length(input),  2
{gamma, epsilon} = DAY3.sum_list(input) |> DAY3.gamma_and_epsilon(cutoff)

IO.puts(gamma*epsilon)

ox_rating = DAY3.find_rating(input, 0, true)
co2_rating = DAY3.find_rating(input, 0, false)
IO.puts ox_rating*co2_rating
