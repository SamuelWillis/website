defmodule SamuelWillisWeb.Plugs.Bots.PutTDMReservationHeaders do
  @moduledoc """
  Sets XRobotsTag & TDM Reservation header.

  See [TDM Reservation
  Protocol](https://www.w3.org/community/reports/tdmrep/CG-FINAL-tdmrep-20240202/).

  See [X-Robots-Tag header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Ro bots-Tag).
  """
  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    conn
    |> put_resp_header("tdm-reservation", "1")
    |> put_resp_header("x-robots-tag", "noai, noimageai")
  end
end
