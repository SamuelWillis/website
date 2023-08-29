defmodule SamuelWillis.Metrics.Worker do
  @moduledoc """
  Handles writing Metrics to the Database

  This worker allows our database writes to occur in a separate process which
  allows the display of the website content if there are errors writing the
  Metrics.

  Batches the writes to the database every X seconds.

  When the application is shutting down, `terminate/2` will write any pending
  upserts to the database.
  """
  use GenServer, restart: :temporary

  alias SamuelWillis.Metrics

  @registry SamuelWillis.Metrics.Registry
  @upsert_min_wait_time 10
  @upsert_max_wait_time 20

  def start_link(path) do
    GenServer.start_link(__MODULE__, [path: path], name: {:via, Registry, {@registry, path}})
  end

  @impl GenServer
  def init(init_args) do
    path = Keyword.fetch!(init_args, :path)

    opts =
      Keyword.get(init_args, :opts,
        upsert_min_wait_time: @upsert_min_wait_time,
        upsert_max_wait_time: @upsert_max_wait_time
      )

    # Trap exists so that `terminate/2` is called when application is shutting
    # down.
    Process.flag(:trap_exit, true)

    # Initialize the start state to {path, 0}
    {:ok, {path, _visits = 0, _opts = opts}}
  end

  @impl GenServer
  def handle_info(:track_metrics, {path, 0, opts}) do
    upsert_min_wait_time = Keyword.get(opts, :upsert_min_wait_time)
    upsert_max_wait_time = Keyword.get(opts, :upsert_max_wait_time)

    upsert_wait_time = Enum.random(upsert_min_wait_time..upsert_max_wait_time) * 1_000

    # Schedule upsert to happen at a random time between 10 and 20 seconds from
    # now. This avoids processes that are spawned at the same time all
    # attempting to write to the database at the same time.
    Process.send_after(self(), :upsert, upsert_wait_time)

    {:noreply, {path, 1, opts}}
  end

  def handle_info(:track_metrics, {path, visits, opts}) do
    {:noreply, {path, visits + 1, opts}}
  end

  def handle_info(:upsert, {path, visits, opts}) do
    Metrics.upsert!(path, visits)

    {:noreply, {path, 0, opts}}
  end

  @impl GenServer
  def terminate(_, {_path, 0, _opts}), do: :ok
  def terminate(_, {path, visits, _opts}), do: Metrics.upsert!(path, visits)
end
