defmodule SamuelWillis.Repo do
  use Ecto.Repo,
    otp_app: :samuel_willis,
    adapter: Ecto.Adapters.Postgres
end
