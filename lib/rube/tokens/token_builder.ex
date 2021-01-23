defmodule Rube.Tokens.TokenBuilder do
  use GenServer
  alias Rube.Tokens

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
    with {:ok, token} <- fetch_token(blockchain_id, address) do
      {:ok, _} = Tokens.TokenStore.put(token)
    end

    {:noreply, state}
  end

  defp fetch_token(blockchain_id, address) do
    with {:ok, blockchain} <- Slurp.Blockchains.find(blockchain_id),
         {:ok, symbol} <- Tokens.Contract.symbol(blockchain, address),
         {:ok, decimals} <- Tokens.Contract.decimals(blockchain, address) do
      token = %Tokens.Token{
        blockchain_id: blockchain_id,
        address: address,
        symbol: symbol,
        precision: decimals
      }

      {:ok, token}
    end
  end
end
