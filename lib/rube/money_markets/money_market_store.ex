defmodule Rube.MoneyMarkets.MoneyMarketStore do
  use Stored.Store

  def after_put(money_market) do
    Phoenix.PubSub.broadcast(
      Rube.PubSub,
      "after_put_money_market",
      {"after_put_money_market", money_market}
    )
  end
end
