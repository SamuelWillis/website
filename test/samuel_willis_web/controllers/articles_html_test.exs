defmodule SamuelWillisWeb.ArticlesHTMLTest do
  use SamuelWillisWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias SamuelWillis.Blog
  alias SamuelWillisWeb.ArticlesHTML

  describe "navigation/1" do
    test "renders previous article link" do
      [previous_article | _] = Blog.list_articles()

      html =
        render_component(&ArticlesHTML.navigation/1,
          previous_article: previous_article,
          next_article: nil
        )

      assert html =~ "/articles/#{previous_article.id}"
      assert html =~ previous_article.title
    end

    test "renders next article link" do
      [next_article | _] = Blog.list_articles()

      html =
        render_component(&ArticlesHTML.navigation/1,
          previous_article: nil,
          next_article: next_article
        )

      assert html =~ "/articles/#{next_article.id}"
      assert html =~ next_article.title
    end

    test "renders both previous and next links" do
      [next_article, previous_article | _] = Blog.list_articles()

      html =
        render_component(&ArticlesHTML.navigation/1,
          previous_article: previous_article,
          next_article: next_article
        )

      assert html =~ "/articles/#{previous_article.id}"
      assert html =~ previous_article.title

      assert html =~ "/articles/#{next_article.id}"
      assert html =~ next_article.title
    end
  end
end
