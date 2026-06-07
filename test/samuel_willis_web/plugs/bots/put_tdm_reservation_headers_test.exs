defmodule SamuelWillisWeb.Plugs.Bots.PutTDMReservationHeadersTest do
  use SamuelWillisWeb.ConnCase, async: true

  describe "call/2" do
    test "adds headers to response" do
      response = get(build_conn(), "/")

      assert Plug.Conn.get_resp_header(response, "x-robots-tag") == ["noai, noimageai"]
    end
  end
end
