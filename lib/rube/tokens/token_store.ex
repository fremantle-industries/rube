defmodule Rube.Tokens.TokenStore do
  use Stored.Store

  def after_put(token) do
    Phoenix.PubSub.broadcast(Slurpee.PubSub, "after_put_token", {"after_put_token", token})
  end
end
