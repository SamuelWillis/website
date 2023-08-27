defmodule SamuelWillis.Repo.Migrations.CreateMetrics do
  use Ecto.Migration

  @doc """
  Add the analytics table

  Stores data about the number of visits a path has on a given day.

  Since the analytics are concerned with tracking page views per day a composite
  primary key comprised of the date and path columns is used.

  This will allow easy inserts, updates, and retrievals of analytics based on
  the day and path.
  """
  def change do
    create table(:metrics, primary_key: false) do
      add :date, :date, primary_key: true
      add :path, :string, primary_key: true
      add :visits, :integer, default: 0
    end
  end
end
