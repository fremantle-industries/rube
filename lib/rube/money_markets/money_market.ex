defmodule Rube.MoneyMarkets.MoneyMarket do
  alias __MODULE__

  @type t :: %MoneyMarket{
          blockchain_id: Slurp.Blockchains.Blockchain.id(),
          address: term,
          symbol: String.t(),
          precision: non_neg_integer()
        }

  defstruct ~w[blockchain_id address symbol precision]a

  defimpl Stored.Item do
    def key(money_market), do: {money_market.blockchain_id, money_market.address}
  end
end
