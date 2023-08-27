defmodule SamuelWillis.Metrics.Metric do
  @moduledoc """
  A representation of a path's metrics for a given day
  """

  use Ecto.Schema

  @primary_key false
  schema "metrics" do
    field :date, :date, primary_key: true
    field :path, :string, primary_key: true
    field :visits, :integer, default: 0
  end
end
