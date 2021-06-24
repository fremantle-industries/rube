defmodule Rube.Amm.PairIndexer do
  use GenServer
  alias Rube.Amm
  require Logger

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: Slurp.Adapter.address()

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
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
  def handle_cast({:ensure, blockchain_id, address}, state) do
    with {:error, :not_found} <- Amm.find_pair(blockchain_id, address),
         {:error, reason} <- Amm.PairBuilder.fetch(blockchain_id, address) do
      Logger.error(
        "could not fetch pair - reason: #{inspect(reason)}, blockchain_id: #{blockchain_id}, address: #{address}"
      )
    end

    {:noreply, state}
  end
end
