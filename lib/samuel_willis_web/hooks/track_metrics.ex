defmodule SamuelWillisWeb.Hooks.TrackMetrics do
  @moduledoc """
  TrackMetrics Hook

  Responsible for ensuring Metrics are tracked on LiveViews
  """
  import Phoenix.LiveView

  alias SamuelWillis.Metrics

  @ignore_paths ["/metrics"]

  def on_mount(:default, _params, _session, socket),
    do: {:cont, attach_hook(socket, :track_metrics, :handle_params, &track_metrics/3)}

  def track_metrics(_params, uri, socket) do
    uri = URI.parse(uri)

    start_async(socket, :track_metrics, fn ->
      if uri.path not in @ignore_paths do
        Metrics.track_metrics(uri.path)
      end
    end)

    {:cont, socket}
  end
end
