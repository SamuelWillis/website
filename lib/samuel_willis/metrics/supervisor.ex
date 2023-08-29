defmodule SamuelWillis.Metrics.Supervisor do
  @moduledoc """
  Metrics Supervisor

  Handles the supervision of Workers spawned to write metrics to the database.

  Each time a user accesses a path this supervisor spawns an Elixir process to
  track the accesses to that path. If a process already exists a message is sent
  to the process instead.

  It does this via a Registry to enable look ups of existing processes and a
  DynamicSupervisor to handle supervising the dynamically spawned write
  processes.

  The advantage to this is that failures to write the metrics to the database do
  not prevent a page from rendering.
  """
  use Supervisor

  @worker SamuelWillis.Metrics.Worker
  @registry_name SamuelWillis.Metrics.Registry
  @dynamic_supervisor_name SamuelWillis.Metrics.DynamicSupervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl Supervisor
  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: @registry_name},
      {DynamicSupervisor, name: @dynamic_supervisor_name, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end

  @doc """
  Tracks the metrics at a given path.

  Checks for an existing process for the path, if none exists a new process is
  started.
  """
  def track_metrics(path) when is_binary(path) do
    pid =
      case Registry.lookup(@registry_name, path) do
        [{pid, _}] ->
          pid

        [] ->
          # Handle two users accessing a page without a worker at the exact same time.
          case DynamicSupervisor.start_child(@dynamic_supervisor_name, {@worker, path}) do
            {:ok, pid} -> pid
            {:error, {:already_started, pid}} -> pid
          end
      end

    send(pid, :track_metrics)
  end
end
