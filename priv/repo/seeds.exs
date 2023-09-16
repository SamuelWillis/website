# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SamuelWillis.Repo.insert!(%SamuelWillis.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

paths = ["/", "/articles", "/about"]
today = Date.utc_today()

metric_attrs =
  for number_of_days_ago <- -1..-7, path <- paths, into: [] do
    date = Date.add(today, number_of_days_ago)
    visits = Enum.random(1..20)

    %{
      date: date,
      path: path,
      visits: visits
    }
  end

SamuelWillis.Repo.insert_all(SamuelWillis.Metrics.Metric, metric_attrs)
