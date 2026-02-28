defmodule SamuelWillisWeb.HomeLive do
  use SamuelWillisWeb, :live_view

  @images [
    %{
      name: "mammoth.jpg",
      sm_name: "mammoth-sm.jpg",
      alt: "Image of a snowy mountain in the Canadian Rockies",
      width: 768,
      height: 512
    },
    %{
      name: "mountain.jpg",
      sm_name: "mountain-sm.jpg",
      alt: "Image of a snow capped mountain in British Columbia",
      width: 768,
      height: 512
    },
    %{
      name: "road.jpg",
      sm_name: "road-sm.jpg",
      alt: "Image of an abandoned road",
      width: 768,
      height: 512
    },
    %{
      name: "rock.jpg",
      sm_name: "rock-sm.jpg",
      alt: "Image of a person bouldering",
      width: 768,
      height: 512
    },
    %{
      name: "train.jpg",
      sm_name: "train-sm.jpg",
      alt: "Image of a train track crossing above a valley river",
      width: 768,
      height: 512
    },
    %{
      name: "valley.jpg",
      sm_name: "valley-sm.jpg",
      alt: "Image of a valley with a large river in it",
      width: 768,
      height: 512
    },
    %{
      name: "waterfall.jpg",
      sm_name: "waterfall-sm.jpg",
      alt: "Image of a waterfall",
      width: 768,
      height: 512
    },
    %{
      name: "fountain.jpg",
      sm_name: "fountain-sm.jpg",
      alt: "Image of a fountain in CDMX",
      width: 768,
      height: 512
    },
    %{
      name: "house.jpg",
      sm_name: "house-sm.jpg",
      alt: "Image of a house",
      width: 768,
      height: 512
    }
  ]

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket = socket |> assign(:image, Enum.random(@images))

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} page_visits={@page_visits}>
      <div class="flex-1 flex flex-col items-center sm:grid sm:grid-cols-2 sm:gap-6 space-y-6">
        <button
          class="group hidden focus:outline-none relative cursor-pointer"
          phx-click={
            JS.transition({"animate-single-spin", "", ""}, to: ".refresh-icon", time: "1000")
            |> JS.push("refresh_image")
          }
          phx-connected={JS.show()}
        >
          <img
            src={~p"/images/#{@image.sm_name}"}
            srcset={
              "#{~p"/images/#{@image.sm_name}"} 384w, #{~p"/images/#{@image.name}"} 768w"
            }
            sizes="(min-width: 640px) 50vw, 100vw"
            width={@image.width}
            height={@image.height}
            class="w-96 object-cover focus:outline-none"
            alt={@image.alt}
            loading="eager"
            fetchpriority="high"
            decoding="async"
          />
          <div class="absolute inset-0 flex justify-center items-center bg-base-100/60 p-6 opacity-0 transition-opacity group-hover:opacity-100 group-focus-visible:opacity-100">
            <.icon name="hero-arrow-path" class="size-15 refresh-icon" />
          </div>
          <span class="sr-only">Refresh Image</span>
        </button>
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

  @impl Phoenix.LiveView
  def handle_event("refresh_image", _params, socket) do
    %{image: image} = socket.assigns

    new_image = @images |> Enum.reject(&(&1.name == image.name)) |> Enum.random()

    {:noreply, assign(socket, :image, new_image)}
  end
end
