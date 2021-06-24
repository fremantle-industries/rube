defmodule Rube.Amm.PairStore do
  use Stored.Store

  def after_put(pair) do
    Phoenix.PubSub.broadcast(Slurpee.PubSub, "after_put_pair", {"after_put_pair", pair})
  end
end
