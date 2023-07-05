defmodule SamuelWillis.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :samuel_willis,
    adapter: Ecto.Adapters.Postgres
end
