defmodule SamuelWillis.Metrics.WorkerTest do
  use SamuelWillis.DataCase, async: true

  alias SamuelWillis.Metrics.Worker

  @path "/some/path"
  @opts [upsert_min_wait_time: 0, upsert_max_wait_time: 0]

  describe "init/1" do
    test "initializes with the correct state" do
      assert {:ok, {@path, 0, opts}} = Worker.init(path: @path)
      assert [upsert_min_wait_time: 10, upsert_max_wait_time: 20] = opts
    end

    test "initializes with the correct state with opts" do
      assert {:ok, {@path, 0, @opts}} = Worker.init(path: @path, opts: @opts)
    end
  end

  describe "handle_info/2" do
    test "sets visits to 1 for first metric tracked" do
      old_state = {@path, 0, @opts}

      assert {:noreply, {@path, 1, @opts}} = Worker.handle_info(:track_metrics, old_state)

      assert_receive :upsert, 100
    end

    test "increments the state visits" do
      old_state = {@path, 5, @opts}

      assert {:noreply, {@path, 6, @opts}} = Worker.handle_info(:track_metrics, old_state)
    end
  end
end
