defmodule SamuelWillis.MetricsTest do
  @moduledoc false
  alias Telemetry.Metrics
  use SamuelWillis.DataCase, async: true

  alias Telemetry.Metrics
  alias SamuelWillis.Metrics
  alias SamuelWillis.Metrics.Metric

  @path "/test/path"

  describe "get_weekly_metrics/0" do
    test "returns metrics within the last seven days" do
      today = Date.utc_today()

      metric_attrs =
        for number_of_days_ago <- -1..-7 do
          date = Date.add(today, number_of_days_ago)
          visits = Enum.random(1..20)

          %{
            date: date,
            path: @path,
            visits: visits
          }
        end

      Repo.insert_all(Metric, metric_attrs)

      metrics = Metrics.get_weekly_metrics()

      assert Enum.count(metrics) == 7
    end

    test "metrics are grouped by date" do
      today = Date.utc_today()

      metric_attrs =
        for number_of_days_ago <- -1..-7 do
          date = Date.add(today, number_of_days_ago)
          visits = Enum.random(1..20)

          %{
            date: date,
            path: @path,
            visits: visits
          }
        end

      Repo.insert_all(Metric, metric_attrs)

      metrics = Metrics.get_weekly_metrics()

      for number_of_days_ago <- -1..-7 do
        date = Date.add(today, number_of_days_ago)
        assert is_list(metrics[date])
      end
    end

    test "does not return metrics past 7 days ago" do
      date = Date.add(Date.utc_today(), 8)

      Repo.insert(%Metric{
        date: date,
        path: @path,
        visits: 10
      })

      assert %{} = Metrics.get_weekly_metrics()
    end

    test "date groups are ordered by number of visits" do
      today = Date.utc_today()

      first_metric = Repo.insert!(%Metric{date: today, path: "#{@path}/one", visits: 3})
      second_metric = Repo.insert!(%Metric{date: today, path: "#{@path}/two", visits: 2})
      third_metric = Repo.insert!(%Metric{date: today, path: "#{@path}/three", visits: 1})

      metrics = Metrics.get_weekly_metrics()

      assert [first_metric, second_metric, third_metric] == metrics[today]
    end
  end

  describe "upsert/2" do
    test "inserts new metric" do
      assert metric = Metrics.upsert!(@path)

      assert metric.path == @path
      assert metric.visits == 1
    end

    test "inserts new metric with specific visits" do
      assert metric = Metrics.upsert!(@path, 5)

      assert metric.path == @path
      assert metric.visits == 5
    end

    test "upserts existing metric" do
      _existing_metric =
        Repo.insert!(%Metric{date: Date.utc_today(), path: @path, visits: 5})

      assert _metric = Metrics.upsert!(@path)

      # The returned Metric will be out of date with the DB so query to reload
      # is needed.
      updated_metric =
        Repo.one(from m in Metric, where: m.date == ^Date.utc_today() and m.path == ^@path)

      assert updated_metric.path == @path
      assert updated_metric.visits == 6
    end

    test "upserts existing metric with specific visits" do
      _existing_metric = Repo.insert!(%Metric{date: Date.utc_today(), path: @path, visits: 5})

      assert _metric = Metrics.upsert!(@path, 5)

      # The returned Metric will be out of date with the DB so query to reload
      # is needed.
      updated_metric =
        Repo.one(from m in Metric, where: m.date == ^Date.utc_today() and m.path == ^@path)

      assert updated_metric.path == @path
      assert updated_metric.visits == 10
    end

    test "raises error" do
      assert_raise Ecto.ChangeError, fn ->
        Metrics.upsert!(10, "/path")
      end
    end
  end
end
