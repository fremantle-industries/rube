defmodule Rube.Amm.PairStore do
  use Stored.Store

  def after_put(token) do
    Phoenix.PubSub.broadcast(Rube.PubSub, "after_put_pair", {"after_put_pair", token})
  end
end
