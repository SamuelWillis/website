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

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center sm:grid sm:grid-cols-2 sm:gap-6 space-y-6">
      <.home_image />

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
    """
  end

  def home_image(assigns) do
    assigns = assign(assigns, :image, Enum.random(@images))

    ~H"""
    <img src={~p"/images/#{@image.name}"} class="w-96" alt={@image.alt} />
    """
  end
end
