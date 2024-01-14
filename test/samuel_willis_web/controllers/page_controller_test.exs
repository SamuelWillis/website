defmodule SamuelWillisWeb.PageControllerTest do
  use SamuelWillisWeb.ConnCase

  describe "home/2" do
    test "renders successfully", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html = html_response(conn, 200)

      assert html =~ "Samuel Willis"

      # Assert links appear
      assert html =~ "About"
      assert html =~ "/about"
      assert html =~ "Articles"
      assert html =~ "/articles"

      # Assert social links are on screen
      assert html =~ "https://github.com/SamuelWillis"
      assert html =~ "https://www.linkedin.com/in/willissamuel/"
      assert html =~ "mailto:hello@samuelwillis.dev"
    end
  end
end
