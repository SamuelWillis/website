defmodule SamuelWillisWeb.HomeLive do
  use SamuelWillisWeb, :live_view

  @images [
    %{name: "mammoth.jpg", alt: "Image of a snowy mountain in the Canadian Rockies"},
    %{name: "mountain.jpg", alt: "Image of a snow capped mountain in British Columbia"},
    %{name: "road.jpg", alt: "Image of an abandoned road"},
    %{name: "rock.jpg", alt: "Image of a person bouldering"},
    %{name: "train.jpg", alt: "Image of a train track crossing above a valley river"},
    %{name: "valley.jpg", alt: "Image of a valley with a large river in it"},
    %{name: "waterfall.jpg", alt: "Image of a waterfall"},
    %{name: "fountain.jpg", alt: "Image of a fountain in CDMX"},
    %{name: "house.jpg", alt: "Image of a house"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :image, Enum.random(@images))}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} page_visits={@page_visits}>
      <div class="flex-1 flex flex-col items-center sm:grid sm:grid-cols-2 sm:gap-6 space-y-6">
        <img
          src={~p"/images/#{@image.name}"}
          class="hidden w-96 hover:c"
          alt={@image.alt}
          phx-connected={JS.show()}
        />
        <div class="w-96 h-full flex justify-center items-center" phx-connected={JS.hide()}>
          <span class="loading loading-ring loading-md"></span>
        </div>

        <nav class="flex flex-col items-center">
          <ul class="space-y-4 text-xl font-bold">
            <li>
              <.link navigate={~p"/now"} class="link link-primary link-hover">
                Now
              </.link>
            </li>
            <li>
              <.link navigate={~p"/about"} class="link link-primary link-hover">
                About
              </.link>
            </li>
            <li>
              <.link navigate={~p"/articles"} class="link link-primary link-hover">
                Articles
              </.link>
            </li>
          </ul>
        </nav>
      </div>
    </Layouts.app>
    """
  end

  attr :image, :map, required: true

  def home_image(assigns) do
    ~H"""
    """
  end
end
