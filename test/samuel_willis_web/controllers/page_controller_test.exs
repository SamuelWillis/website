defmodule SamuelWillisWeb.PageControllerTest do
  use SamuelWillisWeb.ConnCase

  describe "home/2" do
    test "renders successfully", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert html = html_response(conn, 200)

      assert html =~ "Samuel Willis"
      assert html =~ "https://github.com/SamuelWillis"
      assert html =~ "https://www.linkedin.com/in/willissamuel/"
      assert html =~ "mailto:samuel.w.h.willis@gmail.com"
    end
  end
end
