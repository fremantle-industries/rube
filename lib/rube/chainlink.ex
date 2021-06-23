defmodule Rube.Chainlink do
  alias __MODULE__

  @type feed :: Chainlink.Feed.t()
  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term

  @spec feeds :: [feed]
  def feeds do
    Chainlink.FeedStore.all()
  end

  @spec find_feed(blockchain_id, address) :: {:ok, feed} | {:error, :not_found}
  def find_feed(blockchain_id, address) do
    Chainlink.FeedStore.find({blockchain_id, address})
  end

  @spec get_or_fetch(blockchain_id, address) :: :ok
  def get_or_fetch(blockchain_id, address) do
    Chainlink.FeedIndexer.get_or_fetch(blockchain_id, address)
  end
end
