defmodule SamuelWillisWeb.Plugs.Bots.PutTDMReservationHeader do
  @moduledoc """
  Sets TDM Reservation header.

  See [TDM Reservation
  Protocol](https://www.w3.org/community/reports/tdmrep/CG-FINAL-tdmrep-20240202/).
  """
  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    put_resp_header(conn, "tdm-reservation", "1")
  end
end
