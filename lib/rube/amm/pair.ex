defmodule Rube.Amm.Pair do
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
