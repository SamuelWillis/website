defmodule SamuelWillisWeb.Plugs.AssignPageVisits do
  @moduledoc """
  AssignPageVisits Plug

  Responsible for ensuring page_visits is assigned on static HTML requests
  """
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    assign(conn, :page_visits, SamuelWillis.Metrics.get_path_visits(conn.request_path))
  end
end
