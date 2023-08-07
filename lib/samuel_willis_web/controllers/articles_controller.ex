defmodule SamuelWillisWeb.ArticlesController do
  use SamuelWillisWeb, :controller

  alias SamuelWillis.Blog

  def index(conn, _params) do
    articles = Blog.list_articles()

    render(conn, :index, articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = Blog.get_article(id)

    previous_article = Blog.previous_article(article)

    next_article = Blog.next_article(article)

    render(conn, :show,
      article: article,
      previous_article: previous_article,
      next_article: next_article
    )
  end
end
