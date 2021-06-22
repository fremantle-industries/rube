defmodule Rube.Amm.PairIndexer do
  use GenServer
  alias Rube.{Amm, Tokens}

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get_or_fetch_pair(blockchain_id, address) :: :ok
  def get_or_fetch_pair(blockchain_id, address) do
    GenServer.cast(__MODULE__, {:get_or_fetch_pair, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:get_or_fetch_pair, blockchain_id, address}, state) do
    with {:error, :not_found} <- Amm.find_pair(blockchain_id, address) do
      {:ok, pair} = Amm.PairBuilder.fetch(blockchain_id, address)
      Tokens.get_or_fetch(blockchain_id, pair.token0)
      Tokens.get_or_fetch(blockchain_id, pair.token1)
    end

    {:noreply, state}
  end
end
