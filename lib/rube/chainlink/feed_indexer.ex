defmodule Rube.Chainlink.FeedIndexer do
  use GenServer
  alias Rube.Chainlink

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term
  @type feed :: Chainlink.Feed.t()

  @spec start_link(term) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get(blockchain_id, address) :: {:ok, feed} | {:error, term}
  def get(blockchain_id, address) do
    GenServer.call(__MODULE__, {:get, blockchain_id, address})
  end

  @spec ensure(blockchain_id, address) :: :ok
  def ensure(blockchain_id, address) do
    GenServer.cast(__MODULE__, {:ensure, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:get, blockchain_id, address}, _from, state) do
    result = get_or_fetch(blockchain_id, address)
    {:reply, result, state}
  end

  @impl true
  def handle_cast({:ensure, blockchain_id, address}, state) do
    get_or_fetch(blockchain_id, address)
    {:noreply, state}
  end

  defp get_or_fetch(blockchain_id, address) do
    with {:error, :not_found} <- Chainlink.find_feed(blockchain_id, address) do
      Chainlink.FeedBuilder.fetch(blockchain_id, address)
    end
  end
end
