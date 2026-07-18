defmodule SamuelWillis.GameOfLife.Universe do
  @moduledoc """
  The Universe! 

  Tracks the current state of the universe. This includes the size,
  generation, and cells.

  Provides the interactions available in the universe:
    - build the universe from a state
    - progress to the next generation
  """
  @enforce_keys [:x_size, :y_size, :generation, :cells]

  defstruct [
    :x_size,
    :y_size,
    generation: 0,
    cells: {}
  ]

  @doc """
  Build the universe from a provided state

  The state is expected to be a list of lists.

  The Universe represents the provided state as Tuples for rapid access of state
  at a given cell.
   
  ## Examples
    iex> state = [[0, 0, 1], [0, 1, 1], [0, 0, 0]]
    iex> SamuelWillis.GameOfLife.Universe.start(state)
  """
  def build([[_ | _] | _] = state) do
    y_size = length(state)
    x_size = state |> List.first() |> length()

    %__MODULE__{
      generation: 0,
      x_size: x_size,
      y_size: y_size,
      cells: transform_cells(state)
    }
  end

  @doc """
  Move the universe into the next generatation.

  The new cell state is built as a list then converted to tuples so that:
  1. We have rapid access to the current state of a cell
  2. It is easy to set the new state of a cell

  This does require us to convert the generated new state from a list of lists
  into a Tuple.

  In the new generation, the cells state is calculated as follows:
  1. If the cell is alive and has 2 or 3 alive neighbours, it survives
  2. If the cell is dead and has exactly 3 alive neighbours, it alives
  3. All other cases cause the cell to die (overpopulation, underpopulation, etc)
  """
  def next_generation(%__MODULE__{} = universe) do
    %{x_size: x_size, y_size: y_size, generation: generation} = universe

    cells =
      for y <- 0..(y_size - 1) do
        for x <- 0..(x_size - 1) do
          state = cell_state(universe, x, y)
          live_neighbours = live_neighbours(universe, x, y)

          case({state, live_neighbours}) do
            # Alive, 2 neighbours -> alive
            {1, 2} -> 1
            # Alive, 3 neighbours -> alive
            {1, 3} -> 1
            # Dead, 3 neighbours -> alive
            {0, 3} -> 1
            # All  other cases -> dead
            {_, _} -> 0
          end
        end
      end

    %{universe | cells: transform_cells(cells), generation: generation + 1}
  end

  # Transform the cells from a list to tuples - O(x_size * y_size)
  defp transform_cells(cells) do
    cells |> Enum.map(&List.to_tuple/1) |> List.to_tuple()
  end

  # Get the cell's state - O(1)
  defp cell_state(%{cells: cells}, x, y) do
    cells
    |> elem(y)
    |> elem(x)
  end

  # Calculate the live neighbours.
  defp live_neighbours(universe, current_x, current_y) do
    x_range = (current_x - 1)..(current_x + 1)
    x_valid_range = 0..(universe.x_size - 1)

    y_range = (current_y - 1)..(current_y + 1)
    y_valid_range = 0..(universe.y_size - 1)

    # For each valid [x, y] neighbour, accumulate the count of live ones
    for x <- x_range,
        y <- y_range,
        (x != current_x or y != current_y) and x in x_valid_range and y in y_valid_range,
        reduce: 0 do
      acc -> acc + cell_state(universe, x, y)
    end
  end

  defimpl Inspect do
    def inspect(universe, opts) do
      cell_doc =
        universe.cells
        |> Tuple.to_list()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.map(&Inspect.Algebra.to_doc(&1, opts))
        |> Enum.reduce(fn doc, acc ->
          Inspect.Algebra.line(acc, doc)
        end)

      inside_doc =
        Inspect.Algebra.concat([
          Inspect.Algebra.line(),
          "generation: #{universe.generation},",
          Inspect.Algebra.line(),
          cell_doc
        ])
        |> Inspect.Algebra.nest(2)

      Inspect.Algebra.concat([
        "%Universe{",
        inside_doc,
        Inspect.Algebra.line(),
        "}"
      ])
    end
  end
end
