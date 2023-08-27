defmodule SamuelWillis.Metrics do
  @moduledoc """
  A minimal webpage metrics engine
  """

  alias SamuelWillis.Repo
  alias SamuelWillis.Metrics.Metric

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
