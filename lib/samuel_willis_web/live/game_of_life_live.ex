defmodule SamuelWillisWeb.GameOfLifeLive do
  use SamuelWillisWeb, :live_view

  alias SamuelWillis.GameOfLife

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.life flash={@flash}>
      <div class="flex-1 flex justify-center items-center">
        <canvas
          id="universe"
          width="300"
          height="300"
          phx-hook=".Universe"
          phx-update="ignore"
          data-cells={Jason.encode!(@cells)}
        ></canvas>
        <div class="absolute bottom-4 right-4 flex gap-4">
          <button class="btn btn-ghost btn-error" phx-click="reset">Reset</button>
          <button class="btn btn-primary" phx-click="start" disabled={@simulating}>Start</button>
        </div>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".Universe">
        export default {
          ctx() {
            return this.el.getContext('2d');
          },
          cells() {
            return JSON.parse(this.el.dataset.cells);
          },
          mounted() {
            this.renderCells();
          },
          updated() {
            // Request an animation frame from the browser so that we are not
            // forcing the browser to rerender when it does not need to.
            if (this.animationFrameRequest) {
              cancelAnimationFrame(this.animationFrameRequest);
            }
            this.animationFrameRequest = requestAnimationFrame(() => this.renderCells());
          },
          renderCells() {
            const ctx = this.ctx()
            const cells = this.cells();

            ctx.clearRect(0, 0, this.el.width, this.el.height);

            for (let i = 0; i < cells.length; i++) {
              for (let j = 0; j < cells[i].length; j++) {
                let cell = cells[i][j];
                if (cells[i][j] === 0) {
                  continue;
                }
                ctx.fillStyle = cells[i][j] === 0 ? 'white' : 'green';
                ctx.fillRect(j * 30, i * 30, 30, 30)
              }
            }
          }
        }
      </script>
    </Layouts.life>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    universe = GameOfLife.build(:t_tetromino)
    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)

    socket =
      socket
      |> assign(:page_title, "Game of Life")
      |> assign(:universe, universe)
      |> assign(:cells, cells)
      |> assign(:simulating, false)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("start", _unsigned_params, socket) do
    Process.send_after(self(), :tick, 100)
    {:noreply, assign(socket, :simulating, true)}
  end

  def handle_event("reset", _unsigned_params, socket) do
    universe = GameOfLife.build(:t_tetromino)
    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)

    socket =
      socket
      |> assign(:universe, universe)
      |> assign(:cells, cells)
      |> assign(:simulating, false)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info(:tick, socket) do
    universe = GameOfLife.tick(socket.assigns.universe)
    cells = universe.cells |> Tuple.to_list() |> Enum.map(&Tuple.to_list/1)

    case universe do
      %{generation: 20} ->
        {:noreply, socket}

      _ ->
        socket =
          socket
          |> assign(:universe, universe)
          |> assign(:cells, cells)

        Process.send_after(self(), :tick, 500)

        {:noreply, socket}
    end
  end
end
