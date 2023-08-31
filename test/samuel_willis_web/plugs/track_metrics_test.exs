defmodule SamuelWillisWeb.TrackMetricsTest do
  use SamuelWillisWeb.ConnCase, async: true

  alias SamuelWillisWeb.Plugs.TrackMetrics

  describe "track_path?/2" do
    test "returns true for 200 status code not in ignore paths" do
      assert TrackMetrics.track_path?(200, "/path")
    end

    test "returns false for path in ignore paths" do
      refute TrackMetrics.track_path?(200, "/metrics")
    end

    test "returns false for non 200 status" do
      refute TrackMetrics.track_path?(201, "/path")
      refute TrackMetrics.track_path?(404, "/path")
      refute TrackMetrics.track_path?(500, "/path")
    end
  end
end
