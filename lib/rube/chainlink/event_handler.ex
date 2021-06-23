defmodule Rube.Chainlink.EventHandler do
  alias Rube.Chainlink
  alias Rube.Chainlink.Events

  def handle_event(blockchain, %{"address" => address}, %Events.AnswerUpdated{}) do
    Chainlink.get_or_fetch(blockchain.id, address)
    # TODO: Update feed
  end

  def handle_event(blockchain, %{"address" => address}, %Events.NewRound{}) do
    Chainlink.get_or_fetch(blockchain.id, address)
    # TODO: Update feed
  end

  def handle_event(blockchain, %{"address" => address}, %Events.SubmissionReceived{}) do
    Chainlink.get_or_fetch(blockchain.id, address)
    # TODO: Update feed
  end

  def handle_event(blockchain, %{"address" => address}, %Events.NewTransmission{}) do
    Chainlink.get_or_fetch(blockchain.id, address)
    # TODO: Update feed
  end

  def handle_event(blockchain, %{"address" => address}, %Events.AvailableFundsUpdated{}) do
    Chainlink.get_or_fetch(blockchain.id, address)
    # TODO: Update feed
  end
end
