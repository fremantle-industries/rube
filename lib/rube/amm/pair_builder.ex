defmodule Rube.Amm.PairBuilder do
  use GenServer
  alias Rube.{Amm, Tokens}

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def fetch(blockchain_id, address) do
    GenServer.call(__MODULE__, {:fetch, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:fetch, blockchain_id, address}, _from, state) do
    case fetch_pair(blockchain_id, address) do
      {:ok, pair} = result ->
        {:ok, _} = Amm.PairStore.put(pair)
        {:reply, result, state}

      error ->
        {:reply, error, state}
    end
  end

  defp fetch_pair(blockchain_id, address) do
    with {:ok, blockchain} <- Slurp.Blockchains.find(blockchain_id),
         {:ok, token0_address} <- Amm.PairContract.token0(blockchain, address),
         {:ok, token1_address} <- Amm.PairContract.token1(blockchain, address),
         {:ok, [reserve0, reserve1, _block_timestamp]} <-
           Amm.PairContract.get_reserves(blockchain, address),
         {:ok, decimals} <- Amm.PairContract.decimals(blockchain, address),
         {:ok, k_last} <- Amm.PairContract.k_last(blockchain, address),
         {:ok, price0_cumulative_last} <-
           Amm.PairContract.price0_cumulative_last(blockchain, address),
         {:ok, price1_cumulative_last} <-
           Amm.PairContract.price1_cumulative_last(blockchain, address),
         token0_hex_address <- token0_address |> to_hex_address(),
         token1_hex_address <- token1_address |> to_hex_address(),
         {:ok, token0} <- Tokens.get(blockchain_id, token0_hex_address),
         {:ok, token1} <- Tokens.get(blockchain_id, token1_hex_address) do
      pair = %Amm.Pair{
        blockchain_id: blockchain_id,
        address: address,
        precision: decimals,
        token0: token0_hex_address,
        token0_symbol: token0.symbol,
        token1: token1_hex_address,
        token1_symbol: token1.symbol,
        reserve0: reserve0,
        reserve1: reserve1,
        k_last: k_last,
        price0_cumulative_last: price0_cumulative_last,
        price1_cumulative_last: price1_cumulative_last
      }

      {:ok, pair}
    end
  end

  defp to_hex_address(address) do
    address
    |> Base.encode16(case: :lower)
    |> ExW3.Utils.to_checksum_address()
  end
end
