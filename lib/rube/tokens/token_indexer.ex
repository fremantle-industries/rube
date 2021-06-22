defmodule Rube.Tokens.TokenIndexer do
  use GenServer
  alias Rube.Tokens

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
    with {:error, :not_found} <- Tokens.find(blockchain_id, address) do
      Tokens.TokenBuilder.fetch(blockchain_id, address)
    end

    {:noreply, state}
  end
end
