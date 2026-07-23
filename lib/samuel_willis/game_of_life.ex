defmodule SamuelWillis.GameOfLife do
  @moduledoc """
  Entry point, this will be used to start and track the game

  """
  alias SamuelWillis.GameOfLife.Universe

  @valid_seeds [:t_tetromino]

  def build(seed_name) do
    seed_name
    |> get_seed()
    |> Universe.build()
  end

  def tick(%Universe{} = universe) do
    Universe.next_generation(universe)
  end

  def simulate(seed_name) when seed_name in @valid_seeds do
    universe = build(seed_name)

    do_simulate(universe)
  end

  # Hardcode 10 generation loop
  defp do_simulate(%{generation: 20} = universe), do: universe

  defp do_simulate(universe) do
    universe |> Universe.next_generation() |> do_simulate()
  end

  defp get_seed(:t_tetromino) do
    [
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 1, 1, 1, 0, 0, 0, 0],
      [0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
  end
end
