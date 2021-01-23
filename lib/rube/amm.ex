defmodule Rube.Amm do
  alias __MODULE__

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term
  @type pair :: Amm.Pair.t()

  @spec pairs :: [pair]
  def pairs do
    Amm.PairStore.all()
  end

  @spec find_pair(blockchain_id, address) :: {:ok, pair} | {:error, :not_found}
  def find_pair(blockchain_id, address) do
    Amm.PairStore.find({blockchain_id, address})
  end

  @spec fetch_and_store_pair(blockchain_id, address) :: term
  def fetch_and_store_pair(blockchain_id, address) do
    Amm.PairBuilder.fetch(blockchain_id, address)
  end
end
