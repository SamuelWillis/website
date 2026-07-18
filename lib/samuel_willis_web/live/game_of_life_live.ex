defmodule SamuelWillisWeb.GameOfLifeLive do
  use SamuelWillisWeb, :live_view

  alias SamuelWillis.GameOfLife

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.life flash={@flash}>
      <div class="flex-1 flex justify-center items-center">
        🏗️
      </div>
    </Layouts.life>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Game of Life")
      |> assign(:universe, GameOfLife.build(:t_tetromino))

    {:ok, socket}
  end
end
