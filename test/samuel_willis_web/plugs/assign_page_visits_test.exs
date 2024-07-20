defmodule SamuelWillisWeb.AssignPageVisitsTest do
  use SamuelWillisWeb.ConnCase, async: true

  alias SamuelWillisWeb.Plugs.AssignPageVisits

  describe "call/2"  do
    test "assigns :page_visits", %{conn: conn} do
      conn = conn |> AssignPageVisits.call([])

      assert conn.assigns[:page_visits]
    end
  end
end
