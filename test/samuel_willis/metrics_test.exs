defmodule SamuelWillis.MetricsTest do
  @moduledoc false
  alias Telemetry.Metrics
  use SamuelWillis.DataCase, async: true

  alias Telemetry.Metrics
  alias SamuelWillis.Metrics
  alias SamuelWillis.Metrics.Metric

  @path "/test/path"

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
