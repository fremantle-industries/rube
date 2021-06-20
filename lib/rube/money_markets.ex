defmodule Rube.MoneyMarkets do
  alias __MODULE__

  @type blockchain_id :: Slurp.Blockchains.Blockchain.id()
  @type address :: term
  @type money_market :: MoneyMarkets.MoneyMarket.t()

  @spec all :: [money_market]
  def all do
    MoneyMarkets.MoneyMarketStore.all()
  end

  @spec find_token(blockchain_id, address) :: {:ok, money_market} | {:error, :not_found}
  def find_token(blockchain_id, address) do
    MoneyMarkets.MoneyMarketStore.find({blockchain_id, address})
  end

  @spec fetch_and_store_token(blockchain_id, address) :: term
  def fetch_and_store_token(blockchain_id, address) do
    MoneyMarkets.TokenBuilder.fetch(blockchain_id, address)
  end
end
