defmodule SamuelWillis.BlogTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias SamuelWillis.Blog

  describe "previous_article/1" do
    test "returns the previous article chronologically" do
      [most_recent_article, less_recent_article | _rest] = Blog.list_articles()

      previous_article = Blog.previous_article(most_recent_article)

      assert previous_article == less_recent_article
    end

    test "returns nil when no previous article" do
      least_recent_article = Enum.at(Blog.list_articles(), -1)

      previous_article = Blog.previous_article(least_recent_article)

      assert is_nil(previous_article)
    end
  end

  describe "next_article/1" do
    test "returns the next article chronologically" do
      [most_recent_article, less_recent_article | _rest] = Blog.list_articles()

      next_article = Blog.next_article(less_recent_article)

      assert next_article == most_recent_article
    end

    test "returns nil when no next article" do
      [most_recent_article | _] = Blog.list_articles()

      next_article = Blog.next_article(most_recent_article)

      assert is_nil(next_article)
    end
  end
end
