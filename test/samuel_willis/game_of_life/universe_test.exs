defmodule SamuelWillis.GameOfLife.UniverseTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SamuelWillis.GameOfLife.Universe

  describe "build/1" do
    test "returns universe for valid seed" do
      seed = [[0, 1], [1, 0]]

      assert %Universe{} = universe = Universe.build(seed)

      assert universe.generation == 0
      assert universe.x_size == 2
      assert universe.y_size == 2
      assert seed |> Enum.map(&List.to_tuple/1) |> List.to_tuple() == universe.cells
    end
  end

  describe "cell_state/3" do
    test "returns cell at given x,y coords" do
      seed = [[0, 1], [1, 0]]

      universe = Universe.build(seed)

      assert 0 = Universe.cell_state(universe, 0, 0)
      assert 1 = Universe.cell_state(universe, 1, 0)
    end
  end

  describe "live_neighbours/3" do
    test "handles top left cell" do
      current_x = 0
      current_y = 0

      seed = build_seed(2, 2, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles top middle cell" do
      current_x = 1
      current_y = 0

      seed = build_seed(3, 2, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles top right cell" do
      current_x = 1
      current_y = 0

      seed = build_seed(2, 2, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles middle left cell" do
      current_x = 0
      current_y = 1

      seed = build_seed(2, 3, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles middle middle cell" do
      current_x = 1
      current_y = 1

      seed = build_seed(3, 3, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles middle right cell" do
      current_x = 1
      current_y = 1

      seed = build_seed(2, 3, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles bottom left cell" do
      current_x = 0
      current_y = 1

      seed = build_seed(2, 2, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles bottom middle cell" do
      current_x = 1
      current_y = 1

      seed = build_seed(3, 2, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end

    test "handles bottom right cell" do
      current_x = 1
      current_y = 1

      seed = build_seed(2, 2, current_x, current_y)

      expected_live_cells = seed |> List.flatten() |> Enum.sum()

      universe = Universe.build(seed)

      assert expected_live_cells == Universe.live_neighbours(universe, current_x, current_y)
    end
  end

  describe "new_state" do
    test "alive with 2 neighbours -> alive" do
      assert 1 == Universe.new_state(1, 2)
    end

    test "alive with 3 neighbours -> alive" do
      assert 1 == Universe.new_state(1, 3)
    end

    test "dead with 3 neighbours -> alive" do
      assert 1 == Universe.new_state(0, 3)
    end

    test "alive with 0 neighbours -> dead" do
      assert 0 == Universe.new_state(1, 0)
    end

    test "alive with 1 neighbours -> dead" do
      assert 0 == Universe.new_state(1, 1)
    end

    test "alive with more than 3 neighbours -> dead" do
      assert 0 == Universe.new_state(1, 4)
    end

    test "dead with 0 neighbours -> dead" do
      assert 0 == Universe.new_state(0, 0)
    end

    test "dead with 1 neighbours -> dead" do
      assert 0 == Universe.new_state(0, 1)
    end

    test "dead with 2 neighbours -> dead" do
      assert 0 == Universe.new_state(0, 2)
    end

    test "dead with more than 3 neighbours -> dead" do
      assert 0 == Universe.new_state(0, 4)
    end
  end

  # Build a seed with current x & y always set to zero
  # This allows for simple counting of 1s to assert live neighbours
  defp build_seed(x_size, y_size, current_x, current_y) do
    for y <- 0..(y_size - 1) do
      for x <- 0..(x_size - 1) do
        case {x, y} do
          {^current_x, ^current_y} -> 0
          _x_y_tuple -> Enum.random(0..1)
        end
      end
    end
  end
end
