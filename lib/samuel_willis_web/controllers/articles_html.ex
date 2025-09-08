defmodule SamuelWillisWeb.ArticlesHTML do
  use SamuelWillisWeb, :html

  embed_templates "articles_html/*"

  attr :previous_article, :map, required: true
  attr :next_article, :map, required: true

  def navigation(assigns) do
    ~H"""
    <div class="grid grid-cols-2 gap-4 justify-center items-center p-4 border-t">
      <.link
        :if={@previous_article}
        navigate={~p"/articles/#{@previous_article.id}"}
        class="link link-primary link-hover"
      >
        ← {@previous_article.title}
      </.link>

      <.link
        :if={@next_article}
        navigate={~p"/articles/#{@next_article.id}"}
        class="link link-primary link-hover"
      >
        {@next_article.title} →
      </.link>
    </div>
    """
  end
end
