defmodule SamuelWillisWeb.ArticlesController do
  use SamuelWillisWeb, :controller

  alias SamuelWillis.Blog

  def index(conn, _params) do
    articles = Blog.list_articles()

    render(conn, :index, articles: articles)
  end

  def show(conn, %{"id" => id}) do
    article = Blog.get_article(id)

    render(conn, :show, article: article)
  end
end
