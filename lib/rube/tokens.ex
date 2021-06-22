defmodule Rube.Tokens do
  alias __MODULE__

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term
  @type token :: Tokens.Token.t()

  @spec all :: [token]
  def all do
    Tokens.TokenStore.all()
  end

  @spec find(blockchain_id, address) :: {:ok, token} | {:error, :not_found}
  def find(blockchain_id, address) do
    Tokens.TokenStore.find({blockchain_id, address})
  end

  @spec get_or_fetch(blockchain_id, address) :: :ok
  def get_or_fetch(blockchain_id, address) do
    Tokens.TokenIndexer.get_or_fetch(blockchain_id, address)
  end
end
