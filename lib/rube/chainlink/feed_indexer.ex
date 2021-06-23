defmodule Rube.Chainlink.FeedIndexer do
  use GenServer
  alias Rube.Chainlink

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec get_or_fetch(blockchain_id, address) :: :ok
  def get_or_fetch(blockchain_id, address) do
    GenServer.cast(__MODULE__, {:get_or_fetch, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:get_or_fetch, blockchain_id, address}, state) do
    with {:error, :not_found} <- Chainlink.find_feed(blockchain_id, address) do
      Chainlink.FeedBuilder.fetch(blockchain_id, address)
    end

    {:noreply, state}
  end
end
