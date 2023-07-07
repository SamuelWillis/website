defmodule SamuelWillisWeb.ArticlesControllerTest do
  use SamuelWillisWeb.ConnCase

  describe "index/2" do
    test "renders successfully", %{conn: conn} do
      conn = get(conn, ~p"/articles")

      assert html_response(conn, 200)
    end
  end

  describe "show/2" do
    test "renders successfully", %{conn: conn} do
      conn = get(conn, ~p"/articles/hello-world")

      assert html_response(conn, 200)
    end
  end
end
