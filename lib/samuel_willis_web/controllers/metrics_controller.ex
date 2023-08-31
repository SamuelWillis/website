defmodule SamuelWillisWeb.MetricsController do
  use SamuelWillisWeb, :controller

  def index(conn, _params) do
    metrics =
      SamuelWillis.Metrics.Metric
      |> SamuelWillis.Repo.all()
      |> Enum.sort_by(& &1.date, :desc)

    render(conn, :index, metrics: metrics)
  end
end
