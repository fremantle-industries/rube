defmodule Rube.Tokens.Token do
  alias __MODULE__

  @type t :: %Token{
          blockchain_id: Slurp.Blockchains.Blockchain.id(),
          address: term,
          symbol: String.t(),
          precision: non_neg_integer()
        }

  defstruct ~w[blockchain_id address symbol precision]a

  defimpl Stored.Item do
    def key(token), do: {token.blockchain_id, token.address}
  end
end
