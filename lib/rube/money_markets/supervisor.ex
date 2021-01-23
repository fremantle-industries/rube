defmodule Rube.MoneyMarkets.Supervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      Rube.MoneyMarkets.MoneyMarketStore,
      Rube.MoneyMarkets.TokenBuilder
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
