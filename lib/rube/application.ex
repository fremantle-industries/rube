defmodule Rube.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Rube.Repo,
      RubeWeb.Telemetry,
      {Phoenix.PubSub, name: Rube.PubSub},
      Rube.Tokens.Supervisor,
      Rube.MoneyMarkets.Supervisor,
      Rube.Amm.Supervisor,
      Rube.Chainlink.Supervisor,
      Rube.RecentHeads,
      Rube.RecentEvents,
      RubeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Rube.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RubeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
