defmodule Rube.MoneyMarkets.TokenBuilder do
  use GenServer
  alias Rube.MoneyMarkets

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def fetch(blockchain_id, address) do
    GenServer.cast(__MODULE__, {:fetch, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:fetch, blockchain_id, address}, state) do
    with {:ok, money_market} <- fetch_money_market(blockchain_id, address) do
      {:ok, _} = MoneyMarkets.MoneyMarketStore.put(money_market)
    end

    {:noreply, state}
  end

  defp fetch_money_market(blockchain_id, address) do
    with {:ok, blockchain} <- Slurp.Blockchains.find(blockchain_id),
         {:ok, symbol} <- MoneyMarkets.TokenContract.symbol(blockchain, address),
         {:ok, decimals} <- MoneyMarkets.TokenContract.decimals(blockchain, address) do
      money_market = %MoneyMarkets.MoneyMarket{
        blockchain_id: blockchain_id,
        address: address,
        symbol: symbol,
        precision: decimals
      }

      {:ok, money_market}
    end
  end
end
