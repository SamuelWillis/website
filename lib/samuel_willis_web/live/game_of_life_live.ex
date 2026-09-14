defmodule SamuelWillisWeb.GameOfLifeLive do
  use SamuelWillisWeb, :live_view

  alias SamuelWillis.GameOfLife

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.life flash={@flash}>
      <div class="flex-1 flex justify-center items-center">
        <input id="settings-drawer-toggle" type="checkbox" class="drawer-toggle" />
        <canvas
          id="universe"
          width="300"
          height="300"
          phx-hook="Universe"
          phx-update="ignore"
          data-cells={Jason.encode!(@cells)}
          data-x-size={@universe.x_size}
          data-y-size={@universe.y_size}
        ></canvas>

        <div class="fab">
          <div tabindex="0" role="button" class="btn btn-lg btn-info btn-circle">
            <.icon name="hero-plus" />
          </div>

          <div class="fab-main-action">
            <%= if @simulating do %>
              Stop
              <button class="btn btn-info btn-lg btn-circle" phx-click="reset">
                <.icon name="hero-stop" />
              </button>
            <% else %>
              Start
              <button class="btn btn-info btn-lg btn-circle" phx-click="start" disabled={@simulating}>
                <.icon name="hero-play" />
              </button>
            <% end %>
          </div>
          <div :for={seed <- GameOfLife.seeds()}>
            {seed_name(seed)}
            <button
              class="btn btn-info btn-lg btn-circle"
              phx-click="set-current-seed"
              phx-value-seed={seed}
            >{seed |> seed_name() |> String.first()}</button>
          </div>
        </div>
      </div>
    </Layouts.life>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    current_seed = :t_tetromino
    universe = GameOfLife.build(current_seed)
    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)

    socket =
      socket
      |> assign(:page_title, "Game of Life")
      |> assign(:current_seed, current_seed)
      |> assign(:universe, universe)
      |> assign(:cells, cells)
      |> assign(:tick_timer, nil)
      |> assign(:simulating, false)

    {:ok, socket}
  end

  @impl Phoenix.LiveView

  def handle_event("set-current-seed", unsigned_params, socket) do
    %{tick_timer: tick_timer} = socket.assigns
    %{"seed" => seed} = unsigned_params

    seed = String.to_existing_atom(seed)

    universe = GameOfLife.build(seed)
    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)

    if is_reference(tick_timer), do: Process.cancel_timer(tick_timer)

    socket =
      socket
      |> assign(:universe, universe)
      |> assign(:current_seed, seed)
      |> assign(:cells, cells)
      |> assign(:tick_timer, nil)
      |> assign(:simulating, false)

    {:noreply, socket}
  end

  def handle_event("start", _unsigned_params, socket) do
    timer = Process.send_after(self(), :tick, 500)

    socket =
      socket |> assign(:tick_timer, timer) |> assign(:simulating, true)

    {:noreply, socket}
  end

  def handle_event("reset", _unsigned_params, socket) do
    %{current_seed: current_seed, tick_timer: tick_timer} = socket.assigns

    universe = GameOfLife.build(current_seed)
    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)

    if is_reference(tick_timer), do: Process.cancel_timer(tick_timer)

    socket =
      socket
      |> assign(:universe, universe)
      |> assign(:cells, cells)
      |> assign(:tick_timer, nil)
      |> assign(:simulating, false)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:tick, socket) do
    %{universe: universe} = socket.assigns
    universe = GameOfLife.tick(universe)

    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)
    tick_timer = Process.send_after(self(), :tick, 500)

    socket =
      socket
      |> assign(:universe, universe)
      |> assign(:cells, cells)
      |> assign(:tick_timer, tick_timer)

    {:noreply, socket}
  end

  defp seed_name(:t_tetromino), do: "T Tetromino"
  defp seed_name(:pulsar), do: "Pulsar"
end
