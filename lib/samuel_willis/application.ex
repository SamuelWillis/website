defmodule SamuelWillis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SamuelWillisWeb.Telemetry,
      SamuelWillis.Repo,
      {DNSCluster, query: Application.get_env(:samuel_willis, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SamuelWillis.PubSub},
      # Start a worker by calling: SamuelWillis.Worker.start_link(arg)
      # {SamuelWillis.Worker, arg},
      SamuelWillis.Metrics.Supervisor,
      # Start to serve requests, typically the last entry
      SamuelWillisWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SamuelWillis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SamuelWillisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
