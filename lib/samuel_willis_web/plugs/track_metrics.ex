defmodule SamuelWillisWeb.Plugs.TrackMetrics do
  @moduledoc """
  TrackMetrics Plug

  Responsible for ensuring metrics are tracked.
  """
  import Plug.Conn

  @ignore_paths ["/metrics"]

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    register_before_send(conn, fn conn ->
      request_path = conn.request_path

      if track_path?(conn.status, request_path) do
        SamuelWillis.Metrics.track_metrics(request_path)
      end

      conn
    end)
  end

  @doc false
  def track_path?(status, path) when status == 200 and path not in @ignore_paths do
    true
  end

  def track_path?(_status, _path) do
    false
  end
end
