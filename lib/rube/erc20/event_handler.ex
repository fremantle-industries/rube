defmodule Rube.Erc20.EventHandler do
  alias Rube.Tokens
  alias Rube.Erc20.Events

  def handle_event(blockchain, %{"address" => address}, %Events.Transfer{}) do
    Tokens.get_or_fetch(blockchain.id, address)
  end

  def handle_event(blockchain, %{"address" => address}, %Events.Mint{}) do
    Tokens.get_or_fetch(blockchain.id, address)
  end

  def handle_event(blockchain, %{"address" => address}, %Events.Burn{}) do
    Tokens.get_or_fetch(blockchain.id, address)
  end
end
