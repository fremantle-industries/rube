defmodule Rube.Amm.Pair do
  alias __MODULE__

  @type address :: String.t()
  @type symbol :: Rube.Tokens.Token.symbol()
  @type t :: %Pair{
          blockchain_id: Slurp.Blockchains.Blockchain.id(),
          address: address,
          precision: integer,
          token0: address,
          token1: address,
          reserve0: integer,
          reserve1: integer,
          k_last: integer,
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
