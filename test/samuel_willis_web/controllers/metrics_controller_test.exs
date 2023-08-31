defmodule SamuelWillisWeb.MetricsControllerTest do
  use SamuelWillisWeb.ConnCase, async: true

  describe "index/2" do
    test "renders no metrics", %{conn: conn} do
      conn = get(conn, ~p"/metrics")

      html = html_response(conn, 200)

      assert html =~ "No metrics to display"
    end

    test "renders metrics", %{conn: conn} do
      today_metric = build_metric(path: "/today")

      yesterday_metric = build_metric(date: Date.add(Date.utc_today(), -1), path: "/yesterday")

      conn = get(conn, ~p"/metrics")

      html = html_response(conn, 200)

      today_string = Date.utc_today() |> Date.to_string()
      yesterday_string = Date.utc_today() |> Date.add(-1) |> Date.to_string()

      assert html =~ "#{today_string} #{today_metric.path}: #{today_metric.visits}"
      assert html =~ "#{yesterday_string} #{yesterday_metric.path}: #{yesterday_metric.visits}"

      refute html =~ "No metrics to display"
    end
  end

  @default_attrs %{
    date: Date.utc_today(),
    path: "/some_path",
    visits: 10
  }

  def build_metric(attrs \\ %{}) do
    attrs = Enum.into(attrs, @default_attrs)

    %SamuelWillis.Metrics.Metric{}
    |> Ecto.Changeset.change(attrs)
    |> SamuelWillis.Repo.insert!()
  end
end
