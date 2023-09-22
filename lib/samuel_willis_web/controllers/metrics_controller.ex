defmodule SamuelWillisWeb.MetricsController do
  use SamuelWillisWeb, :controller

  alias SamuelWillis.Metrics

  def index(conn, _params) do
    metrics = Metrics.get_weekly_metrics()

    render(conn, :index, metrics: metrics)
  end
end
