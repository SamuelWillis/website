defmodule SamuelWillisWeb.GameOfLifeLive do
  use SamuelWillisWeb, :live_view

  alias SamuelWillis.GameOfLife

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} page_visits={@page_visits}>
      <div class="flex-1 flex justify-center items-center">
        🏗️
      </div>
    </Layouts.app>
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
