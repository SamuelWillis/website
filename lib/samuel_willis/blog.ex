defmodule SamuelWillis.Blog do
  @moduledoc """
  A minimal filesystem based publishing engine.
  """

  alias SamuelWillis.Blog.Article

  use NimblePublisher,
    build: Article,
    from: Application.app_dir(:samuel_willis, "priv/articles/**/*.md"),
    as: :articles

  # The @articles variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all articles by descending date.
  @articles Enum.sort_by(@articles, & &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @articles |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def list_articles, do: @articles
  def list_tags, do: @tags

  def get_article(id) do
    Enum.find(list_articles(), &(&1.id == id))
  end
end
