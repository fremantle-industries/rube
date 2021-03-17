defmodule Rube.Amm.Pair do
  alias __MODULE__

  @type address :: String.t()
  @type t :: %Pair{
          blockchain_id: Slurp.Blockchains.Blockchain.id(),
          address: address,
          precision: term,
          token0: term,
          token1: term,
          reserve0: term,
          reserve1: term,
          k_last: term,
          price0_cumulative_last: term,
          price1_cumulative_last: term
        }

  defstruct ~w[
    blockchain_id
    address
    precision
    token0
    token1
    reserve0
    reserve1
    k_last
    price0_cumulative_last
    price1_cumulative_last
  ]a

  defimpl Stored.Item do
    def key(pair), do: {pair.blockchain_id, pair.address}
  end
end
