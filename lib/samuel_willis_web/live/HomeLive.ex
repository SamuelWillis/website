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
          class="hidden w-96"
          alt={@image.alt}
          phx-connected={JS.show()}
        />
        <div class="w-96 h-full flex justify-center items-center" phx-connected={JS.hide()}>
          <svg
            class="animate-spin h-5 w-5"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
            </circle>
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            >
            </path>
          </svg>
        </div>

        <nav class="flex flex-col items-center">
          <ul class="space-y-4 text-xl font-bold">
            <li>
              <.link
                navigate={~p"/now"}
                class="px-4 py-2 font-semibold text-xl rounded-sm
              hover:text-indigo-800
              focus:text-indigo-800 focus:outline-dashed focus:outline-2 focus:outline-offset-0 focus:outline-indigo-500"
              >
                Now
              </.link>
            </li>
            <li>
              <.link
                navigate={~p"/about"}
                class="px-4 py-2 font-semibold text-xl rounded-sm
              hover:text-indigo-800
              focus:text-indigo-800 focus:outline-dashed focus:outline-2 focus:outline-offset-0 focus:outline-indigo-500"
              >
                About
              </.link>
            </li>
            <li>
              <.link
                navigate={~p"/articles"}
                class="px-4 py-2 font-semibold text-xl rounded-sm
              hover:text-indigo-800
              focus:text-indigo-800 focus:outline-dashed focus:outline-2 focus:outline-offset-0 focus:outline-indigo-500"
              >
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
