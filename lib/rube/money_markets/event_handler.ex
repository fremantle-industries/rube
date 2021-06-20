defmodule Rube.MoneyMarkets.EventHandler do
  alias Rube.MoneyMarkets

  def handle_event(blockchain, %{"address" => address}, %MoneyMarkets.Events.AccrueInterest{}) do
    case MoneyMarkets.find_token(blockchain.id, address) do
      {:error, :not_found} -> MoneyMarkets.fetch_and_store_token(blockchain.id, address)
      _ -> nil
    end
  end
end
