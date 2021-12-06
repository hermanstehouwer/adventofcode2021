defmodule Lanternfish do
  defstruct fishes: Nil

  # {days_left -> count}
  @type t :: %__MODULE__{
   fishes: %{integer() => integer()}
  }

  def fromlist(list) do
    fishes = list |> Enum.reduce(%{}, fn(days, acc) -> Map.update(acc, days, 1, &(&1 + 1)) end)
    %Lanternfish{fishes: fishes}
  end

  def step_fish({0, count}, acc) do
    Map.update(Map.merge(acc, %{8 => count}), 6, count, fn old_count -> old_count + count end)
  end

  def step_fish({idx, count}, acc) do
    Map.update(acc, idx-1, count, fn old_count -> old_count + count end)
  end

  @spec step(Lanternfish.t())::Lanternfish.t()
  def step(fishes) do
    new_fishes = Map.to_list(fishes.fishes)
    |> Enum.reduce(%{}, &step_fish/2)
    %Lanternfish{fishes | fishes: new_fishes}
  end

  @spec n_steps(Lanternfish.t(), integer())::Lanternfish.t()
  def n_steps(fishes, count)

  def n_steps(fishes, 0) do
    fishes
  end

  def n_steps(fishes, n) do
    n_steps(step(fishes), n-1)
  end

  @spec count(Lanternfish.t())::integer()
  def count(fishes) do
    Enum.sum(Map.values(fishes.fishes))
  end
end
