defmodule SamuelWillisWeb.MetricsControllerTest do
  use SamuelWillisWeb.ConnCase, async: true

  describe "index/2" do
    test "renders no metrics", %{conn: conn} do
      conn = get(conn, ~p"/metrics")

      html = html_response(conn, 200)

      assert html =~ "Metrics!"
      assert html =~ "No metrics to display"
    end

    test "renders metrics from last week", %{conn: conn} do
      build_metrics()

      conn = get(conn, ~p"/metrics")

      html = html_response(conn, 200)

      today_string = Date.utc_today() |> Date.to_string()
      seven_days_ago_string = Date.utc_today() |> Date.add(-7) |> Date.to_string()

      assert html =~ "Metrics!"
      assert html =~ "#{today_string}"
      assert html =~ "#{seven_days_ago_string}"

      refute html =~ "No metrics to display"
    end
  end

  @paths ["/", "/articles", "/about"]
  def build_metrics do
    today = Date.utc_today()

    metric_attrs =
      for number_of_days_ago <- 0..-7, path <- @paths, into: [] do
        date = Date.add(today, number_of_days_ago)
        visits = Enum.random(1..20)

        %{
          date: date,
          path: path,
          visits: visits
        }
      end

    SamuelWillis.Repo.insert_all(SamuelWillis.Metrics.Metric, metric_attrs)
  end
end
