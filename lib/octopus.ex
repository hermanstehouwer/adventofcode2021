defmodule Octopus do
  defstruct octopi: Nil,
            flashes: 0,
            steps: 0


  def get_neighbours({x,y}) do
    [{-1,0}, {1,0}, {0,-1}, {0,1}, {-1,-1}, {-1,1}, {1,-1}, {1,1}]
    |> Enum.map(fn {c,d} -> {x+c, y+d} end)
  end

  def get_flashing(octopus, have_flashed) do
    Map.to_list(octopus.octopi)
    |> Enum.filter(fn {_key, val} -> val > 9 end)
    |> Enum.map(fn {key, _val} -> key end)
    |> Enum.filter(fn key -> !(key in have_flashed) end)
    |> Enum.filter(fn key -> key in Map.keys(octopus.octopi) end)
  end

  def get_to_add(to_flash, octopus) do
    Enum.map(to_flash, &get_neighbours/1)
    |> List.flatten()
    |> Enum.filter(fn key -> key in Map.keys(octopus.octopi) end)
  end

  def add_one_reducer(key, octopus) do
      %{octopus | octopi: Map.update(octopus.octopi, key, 0, fn x -> x + 1 end)}
  end

  def flash(octopus, have_flashed \\ [])

  def flash(octopus, have_flashed) do
    to_flash = get_flashing(octopus, have_flashed)
    new_octopus = Enum.reduce(get_to_add(to_flash, octopus), octopus, &add_one_reducer/2)
    if length(to_flash) == 0 do
      {new_octopus, have_flashed}
    else
      flash(%{new_octopus | flashes: new_octopus.flashes + length(to_flash)}, have_flashed ++ to_flash)
    end
  end

  def zero_out_flashed(octopus, flashed) do
    to_zero = Enum.map(flashed, fn key -> {key, 0} end) |> Map.new()
    %{octopus | octopi: Map.merge(octopus.octopi, to_zero)}
  end

  def step(octopus, n_steps, find_step \\ false)

  def step(octopus, 0, _find_step) do octopus end

  def step(octopus, n_steps, find_step) do
    raised_octopi = Map.to_list(octopus.octopi) |> Enum.map(fn {key,val} -> {key, val+1} end) |> Map.new()
    raised = %{octopus | octopi: raised_octopi, steps: octopus.steps + 1}
    {new_octopus, flashed} = flash(raised)
    newest_octopus = zero_out_flashed(new_octopus, flashed)
    if find_step and map_size(newest_octopus.octopi) == length(flashed) do
      newest_octopus
    else
      step(newest_octopus, n_steps - 1, find_step)
    end
  end
end
