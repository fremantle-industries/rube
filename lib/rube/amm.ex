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

  @spec ensure(blockchain_id, address) :: :ok
  def ensure(blockchain_id, address) do
    Amm.PairIndexer.ensure(blockchain_id, address)
  end

  @spec put_pair(pair) :: term
  def put_pair(pair) do
    Amm.PairStore.put(pair)
  end
end
