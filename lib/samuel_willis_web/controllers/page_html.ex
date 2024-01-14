defmodule SamuelWillisWeb.PageHTML do
  use SamuelWillisWeb, :html

  embed_templates "page_html/*"

  @images [
    %{name: "mammoth.jpg", alt: "Image of a snowy mountain in the Canadian Rockies"},
    %{name: "mountain.jpg", alt: "Image of a snow capped mountain in British Columbia"},
    %{name: "road.jpg", alt: "Image of an abandoned road"},
    %{name: "rock.jpg", alt: "Image of a person bouldering"},
    %{name: "train.jpg", alt: "Image of a train track crossing above a valley river"},
    %{name: "valley.jpg", alt: "Image of a valley with a large river in it"},
    %{name: "waterfall.jpg", alt: "Image of a waterfall"},
  ]

  def home_image(assigns) do
    assigns = assign(assigns, :image, Enum.random(@images))
    ~H"""
      <img src={~p"/images/#{@image.name}"} class="w-96" alt={@image.alt} />
    """
  end
end
