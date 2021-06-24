defmodule Rube.Tokens.TokenBuilder do
  use GenServer
  alias Rube.Tokens
  alias Slurp.Blockchains

  @type blockchain_id :: Blockchains.Blockchain.id()
  @type address :: term
  @type token :: Tokens.Token.t()
  @type fetch_result :: {:ok, token} | {:error, term}

  @spec start_link(list) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec fetch(blockchain_id, address) :: fetch_result
  def(fetch(blockchain_id, address)) do
    GenServer.call(__MODULE__, {:fetch, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:fetch, blockchain_id, address}, _from, state) do
    case fetch_token(blockchain_id, address) do
      {:ok, token} = ok ->
        Tokens.TokenStore.put(token)
        {:reply, ok, state}

      {:error, _reason} = error ->
        {:reply, error, state}
    end
  end

  defp fetch_token(blockchain_id, address) do
    with {:ok, blockchain} <- Blockchains.find(blockchain_id),
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
