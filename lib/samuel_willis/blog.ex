defmodule SamuelWillis.Blog do
  @moduledoc """
  A minimal filesystem based publishing engine.
  """

  alias SamuelWillis.Blog.Article

  use NimblePublisher,
    build: Article,
    from: Application.app_dir(:samuel_willis, "priv/articles/**/*.md"),
    as: :articles,
    highlighters: []

  # The @articles variable is first defined by NimblePublisher.
  # Let's further modify it by filtering unpublished articles and sorting all
  # articles by descending date
  @articles @articles |> Enum.filter(& &1.published) |> Enum.sort_by(& &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @articles |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  def list_articles, do: @articles
  def list_tags, do: @tags

  def get_article(id) do
    Enum.find(list_articles(), &(&1.id == id))
  end

  @doc """
  Finds the article before the provided article.

  Returns `nil` if article is the first article.
  """
  def previous_article(%Article{} = article) do
    articles = list_articles()

    index = Enum.find_index(articles, &(&1.id == article.id))

    Enum.at(articles, index + 1, nil)
  end

  @doc """
  Finds the article after the provided article

  Returns `nil` if the article is the last article.
  """
  def next_article(%Article{} = article) do
    articles = list_articles()

    index = Enum.find_index(articles, &(&1.id == article.id))

    if index != 0 do
      Enum.at(articles, index - 1)
    else
      nil
    end
  end
end
