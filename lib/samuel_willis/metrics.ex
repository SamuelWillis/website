defmodule SamuelWillis.Metrics do
  @moduledoc """
  A minimal webpage metrics engine
  """
  import Ecto.Query, only: [from: 2]

  alias SamuelWillis.Repo
  alias SamuelWillis.Metrics.Metric
  alias SamuelWillis.Metrics.Supervisor

  defdelegate track_metrics(path), to: Supervisor, as: :track_metrics

  @spec get_path_visits(String.t()) :: integer()
  def get_path_visits(path) do
    query =
      from m in Metric,
        where: m.path == ^path

    query |> Repo.aggregate(:sum, :visits) || 0
  end

  def get_weekly_metrics() do
    today = Date.utc_today()
    start_date = Date.add(today, -7)

    query =
      from m in Metric,
        where: m.date <= ^today,
        where: ^start_date <= m.date,
        order_by: [desc: m.visits]

    query
    |> Repo.all()
    |> Enum.group_by(& &1.date)
  end

  @doc """
  Upsert a SamuelWillis.Metrics.Metric for the given path

  Upserts the given path's metrics with the provided `visits` count.

  *Note:* In the case of an upsert, the updated metric will not be returned.
  [See the docs](https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert/2-upserts)

  Since these upserts are expected to occur in the background, it is not
  expected that the return of the upsert will be used. Thus it is acceptable
  (for now) that the returned schema is out of sync with the DB. If this
  assumption changes one of the suggested strategies in the ddocs will need to
  be employed.
  """
  def upsert!(path, visits \\ 1) do
    date = Date.utc_today()

    Repo.insert!(
      %Metric{date: date, path: path, visits: visits},
      on_conflict: [inc: [visits: visits]],
      conflict_target: [:date, :path]
    )
  end
end
