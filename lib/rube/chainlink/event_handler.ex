defmodule Rube.Chainlink.EventHandler do
  alias Rube.Chainlink

  def handle_event(blockchain, %{"address" => address}, %Chainlink.Events.AnswerUpdated{}) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:error, :not_found} -> Chainlink.fetch_and_store_feed(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Chainlink.Events.NewRound{}) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:error, :not_found} -> Chainlink.fetch_and_store_feed(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Chainlink.Events.SubmissionReceived{}) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:error, :not_found} -> Chainlink.fetch_and_store_feed(blockchain.id, address)
      _ -> nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Chainlink.Events.NewTransmission{}) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:error, :not_found} -> Chainlink.fetch_and_store_feed(blockchain.id, address)
      _ -> nil
    end
  end
end
