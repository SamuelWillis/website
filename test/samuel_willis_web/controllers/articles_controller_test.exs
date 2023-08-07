defmodule SamuelWillisWeb.ArticlesControllerTest do
  use SamuelWillisWeb.ConnCase, async: true

  alias SamuelWillis.Blog

  describe "index/2" do
    test "renders successfully", %{conn: conn} do
      conn = get(conn, ~p"/articles")

      assert html_response(conn, 200)
    end
  end

  describe "show/2" do
    test "renders first article successfully", %{conn: conn} do
      [first_article, next_article | _] = Blog.list_articles()
      conn = get(conn, ~p"/articles/#{first_article.id}")

      assert html_response(conn, 200)

      # Renders next article link
      assert conn.resp_body =~ next_article.title
    end

    test "renders last article successfully", %{conn: conn} do
      last_article = Enum.at(Blog.list_articles(), -1)
      previous_article = Enum.at(Blog.list_articles(), -2)

      conn = get(conn, ~p"/articles/#{last_article.id}")

      assert html_response(conn, 200)

      # Renders next previous link
      assert conn.resp_body =~ previous_article.title
    end
  end
end
