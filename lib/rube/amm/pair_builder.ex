defmodule Rube.Amm.PairBuilder do
  use GenServer
  alias Rube.Amm

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
    with {:ok, pair} <- fetch_pair(blockchain_id, address) do
      {:ok, _} = Amm.PairStore.put(pair)
    end

    {:noreply, state}
  end

  defp fetch_pair(blockchain_id, address) do
    with {:ok, blockchain} <- Slurp.Blockchains.find(blockchain_id),
         {:ok, token0} <- Amm.PairContract.token0(blockchain, address),
         {:ok, token1} <- Amm.PairContract.token1(blockchain, address),
         {:ok, [reserve0, reserve1, _block_timestamp]} <-
           Amm.PairContract.get_reserves(blockchain, address),
         {:ok, decimals} <- Amm.PairContract.decimals(blockchain, address),
         {:ok, k_last} <- Amm.PairContract.k_last(blockchain, address),
         {:ok, price0_cumulative_last} <-
           Amm.PairContract.price0_cumulative_last(blockchain, address),
         {:ok, price1_cumulative_last} <-
           Amm.PairContract.price1_cumulative_last(blockchain, address) do
      pair = %Amm.Pair{
        blockchain_id: blockchain_id,
        address: address,
        precision: decimals,
        token0: token0,
        token1: token1,
        reserve0: reserve0,
        reserve1: reserve1,
        k_last: k_last,
        price0_cumulative_last: price0_cumulative_last,
        price1_cumulative_last: price1_cumulative_last
      }

      {:ok, pair}
    end
  end
end
