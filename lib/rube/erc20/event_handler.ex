defmodule Rube.Erc20.EventHandler do
  alias Rube.Erc20.Events
  alias Rube.Tokens

  @events [
    Events.Approval,
    Events.Transfer
  ]
  def handle_event(blockchain, %{"address" => address}, %event_name{})
      when event_name in @events do
    Tokens.ensure(blockchain.id, address)
  end
end
