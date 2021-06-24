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

  defstruct ~w[
    blockchain_id
    address
    type
    name
    enabled
    precision
    latest_answer
    latest_round
  ]a

  @spec humanize_latest_answer(t) :: Decimal.t()
  def humanize_latest_answer(feed) do
    divisor = 10 |> :math.pow(feed.precision) |> Decimal.from_float()

    feed.latest_answer
    |> Decimal.new()
    |> Decimal.div(divisor)
    |> Decimal.normalize()
  end

  defimpl Stored.Item do
    def key(feed), do: {feed.blockchain_id, feed.address}
  end
end
