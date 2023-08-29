defmodule SamuelWillis.Metrics.SupervisorTest do
  use SamuelWillis.DataCase, async: true

  alias SamuelWillis.Metrics.Supervisor

  @path "/some/path"

  describe "track_metrics/1" do
    test "sends the track metrics message" do
      assert :track_metrics == Supervisor.track_metrics(@path)
    end

    test "sends track metrics message when process exists for path" do
      Supervisor.init(:ok)

      Supervisor.track_metrics(@path)

      assert :track_metrics == Supervisor.track_metrics(@path)
    end
  end
end
