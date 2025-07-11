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
    {:ok,
     assign(socket,
       image: Enum.random(@images),
       gallery_open: false,
       current_image_index: 0,
       images: @images
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="flex-1 flex flex-col items-center sm:grid sm:grid-cols-2 sm:gap-6 space-y-6">
      <img
        src={~p"/images/#{@image.name}"}
        class="hidden w-96 cursor-pointer"
        alt={@image.alt}
        phx-connected={JS.show()}
        phx-click="open_gallery"
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

    <.gallery :if={@gallery_open} images={@images} current_index={@current_image_index} />
    """
  end

  def handle_event("open_gallery", _params, socket) do
    # Find the index of the currently displayed image
    current_index =
      Enum.find_index(@images, fn img -> img.name == socket.assigns.image.name end) || 0

    {:noreply, assign(socket, gallery_open: true, current_image_index: current_index)}
  end

  def handle_event("close_gallery", _params, socket) do
    {:noreply, assign(socket, gallery_open: false)}
  end

  def handle_event("prev_image", _params, socket) do
    new_index =
      if socket.assigns.current_image_index == 0 do
        length(@images) - 1
      else
        socket.assigns.current_image_index - 1
      end

    {:noreply, assign(socket, current_image_index: new_index)}
  end

  def handle_event("next_image", _params, socket) do
    new_index =
      if socket.assigns.current_image_index == length(@images) - 1 do
        0
      else
        socket.assigns.current_image_index + 1
      end

    {:noreply, assign(socket, current_image_index: new_index)}
  end

  def handle_event("select_image", %{"index" => index}, socket) do
    {:noreply, assign(socket, current_image_index: String.to_integer(index))}
  end

  def handle_event("keydown", %{"key" => "Escape"}, socket) do
    {:noreply, assign(socket, gallery_open: false)}
  end

  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    if socket.assigns.gallery_open do
      handle_event("prev_image", %{}, socket)
    else
      {:noreply, socket}
    end
  end

  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    if socket.assigns.gallery_open do
      handle_event("next_image", %{}, socket)
    else
      {:noreply, socket}
    end
  end

  def handle_event("keydown", _params, socket) do
    {:noreply, socket}
  end

  attr :images, :list, required: true
  attr :current_index, :integer, required: true

  def gallery(assigns) do
    ~H"""
    <div
      class="fixed inset-0 bg-gray-900 bg-opacity-75 flex items-center justify-center z-50"
      phx-click="close_gallery"
      phx-window-keydown="keydown"
      phx-key="Escape"
    >
      <div class="max-w-7xl max-h-full w-full h-full flex flex-col items-center justify-center p-4">
        <!-- Close button -->
        <button
          class="absolute top-4 right-4 text-white text-2xl hover:text-gray-300 z-60"
          phx-click="close_gallery"
          aria-label="Close gallery"
        >
          ×
        </button>
        
    <!-- Main image container -->
        <div class="relative flex-1 flex items-center justify-center w-full max-h-[calc(100vh-120px)]">
          <!-- Previous button -->
          <button
            class="absolute left-4 top-1/2 transform -translate-y-1/2 text-white text-4xl hover:text-gray-300 z-10"
            phx-click="prev_image"
            aria-label="Previous image"
          >
            ‹
          </button>
          
    <!-- Current image -->
          <img
            src={~p"/images/#{Enum.at(@images, @current_index).name}"}
            alt={Enum.at(@images, @current_index).alt}
            class="max-w-full max-h-full object-contain"
            phx-click={JS.push("next_image")}
          />
          
    <!-- Next button -->
          <button
            class="absolute right-4 top-1/2 transform -translate-y-1/2 text-white text-4xl hover:text-gray-300 z-10"
            phx-click="next_image"
            aria-label="Next image"
          >
            ›
          </button>
        </div>
        
    <!-- Thumbnails -->
        <div class="flex space-x-2 mt-4 overflow-x-auto max-w-full">
          <div :for={{image, index} <- Enum.with_index(@images)} class="flex-shrink-0">
            <img
              src={~p"/images/#{image.name}"}
              alt={image.alt}
              class={[
                "w-16 h-16 object-cover cursor-pointer border-2 hover:border-white transition-colors",
                if(index == @current_index, do: "border-white", else: "border-gray-600")
              ]}
              phx-click="select_image"
              phx-value-index={index}
            />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
