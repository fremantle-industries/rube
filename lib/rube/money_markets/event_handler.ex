defmodule Rube.MoneyMarkets.EventHandler do
  alias Rube.MoneyMarkets

  def handle_event(blockchain, %{"address" => address}, %Rube.Compound.Events.AccrueInterest{}) do
    case MoneyMarkets.find_token(blockchain.id, address) do
      {:error, :not_found} -> MoneyMarkets.fetch_and_store_token(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Rube.Compound.Events.Borrow{}) do
    case MoneyMarkets.find_token(blockchain.id, address) do
      {:error, :not_found} -> MoneyMarkets.fetch_and_store_token(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Rube.Compound.Events.Redeem{}) do
    case MoneyMarkets.find_token(blockchain.id, address) do
      {:error, :not_found} -> MoneyMarkets.fetch_and_store_token(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Rube.Compound.Events.RepayBorrow{}) do
    case MoneyMarkets.find_token(blockchain.id, address) do
      {:error, :not_found} -> MoneyMarkets.fetch_and_store_token(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Rube.Compound.Events.LiquidateBorrow{}) do
    case MoneyMarkets.find_token(blockchain.id, address) do
      {:error, :not_found} -> MoneyMarkets.fetch_and_store_token(blockchain.id, address)
      _ -> nil
    end
  end
end
