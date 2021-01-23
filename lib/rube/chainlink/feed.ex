defmodule Rube.Chainlink.Feed do
  alias __MODULE__

  @type t :: %Feed{
          blockchain_id: Slurp.Blockchains.Blockchain.id(),
          address: term,
          name: String.t(),
          enabled: boolean,
          precision: non_neg_integer(),
          latest_answer: term,
          latest_round: term
        }

  defstruct ~w[blockchain_id address type name enabled precision latest_answer latest_round]a

  defimpl Stored.Item do
    def key(feed), do: {feed.blockchain_id, feed.address}
  end
end
