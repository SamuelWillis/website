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
          data-x-size={@universe.x_size}
          data-y-size={@universe.y_size}
        ></canvas>
        <div class="absolute bottom-4 right-4 flex gap-4">
          <button class="btn btn-ghost btn-error" phx-click="reset">Reset</button>
          <button class="btn btn-primary" phx-click="start" disabled={@simulating}>Start</button>
        </div>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".Universe">
        export default {
          canvas() {
            return this.el;
          },
          ctx() {
            return this.canvas().getContext('2d');
          },
          cells() {
            return JSON.parse(this.el.dataset.cells);
          },
          baseCellSize() {
            return 30 *this. ratio();
          },
          ratio() {
            return window.devicePixelRatio || 1;
          },
          mounted() {
            this.scaleCanvas();
            this.renderCells();

            addEventListener("resize", (event) => {
              this.scaleCanvas()
              this.renderCells()
            });
          },
          updated() {
            if (this.animationFrameRequest) {
              cancelAnimationFrame(this.animationFrameRequest);
            }
            this.animationFrameRequest = requestAnimationFrame(() => this.renderCells());
          },
          scaleCanvas() {
            // Shout out this gist:
            // https://gist.github.com/callumlocke/cc258a193839691f60dd
            const canvas = this.canvas();
            const ctx = this.ctx();
            const ratio = this.ratio();

            canvas.width = window.innerWidth * ratio;
            canvas.height = window.innerHeight * ratio;
            canvas.style.width = `${window.innerWidth}px`;
            canvas.style.height = `${window.innerHeight}px`;

            const centerX = canvas.width / 2;
            const centerY = canvas.height / 2;

            ctx.translate(centerX, centerY);
            ctx.scale(ratio, ratio)
          },
          renderCells() {
            const canvas = this.canvas();
            const ctx = this.ctx()
            const cells = this.cells();
            const ratio = this.ratio();
            const baseCellSize = this.baseCellSize();

            this.clearCanvas();
            ctx.save();
            ctx.fillStyle = 'green';

            // Calculate initial co-ordinates so that universe is centered on screen.
            const initialX = -1 * baseCellSize * (this.el.dataset.xSize / 2);
            const initialY = -1 * baseCellSize * (this.el.dataset.ySize / 2)

            for (let i = 0; i < cells.length; i++) {
              for (let j = 0; j < cells[i].length; j++) {
                let cell = cells[i][j];

                if (cells[i][j] === 0) {
                  continue;
                }

                const x = initialX + (baseCellSize * j)
                const y = initialY + (baseCellSize * i)

                ctx.fillRect(x, y, baseCellSize, baseCellSize)
              }
            }
            ctx.restore();
          },
          clearCanvas() {
            this.ctx().clearRect(
              -this.canvas().width,
              -this.canvas().height,
              this.el.width * this.ratio(),
              this.el.height * this.ratio()
            );
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
      |> assign(:tick_timer, nil)
      |> assign(:simulating, false)

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("start", _unsigned_params, socket) do
    timer = Process.send_after(self(), :tick, 100)

    socket =
      socket |> assign(:tick_timer, timer) |> assign(:simulating, true)

    {:noreply, socket}
  end

  def handle_event("reset", _unsigned_params, socket) do
    %{tick_timer: tick_timer} = socket.assigns

    universe = GameOfLife.build(:t_tetromino)
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

    case universe do
      %{generation: 20} ->
        {:noreply, socket}

      _ ->
        tick_timer = Process.send_after(self(), :tick, 500)

        socket =
          socket
          |> assign(:universe, universe)
          |> assign(:cells, cells)
          |> assign(:tick_timer, tick_timer)

        {:noreply, socket}
    end
  end
end
