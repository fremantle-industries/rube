defmodule Rube.Chainlink.EventHandler do
  alias Rube.Chainlink
  alias Rube.Chainlink.Events
  require Logger

  def handle_event(blockchain, %{"address" => address}, %Events.NewRound{} = event) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:ok, feed} ->
        updated_feed = %{feed | latest_round: event.round_id}
        Chainlink.put_feed(updated_feed)

      {:error, :not_found} ->
        Chainlink.ensure_feed(blockchain.id, address)
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Events.SubmissionReceived{}) do
    Chainlink.ensure_feed(blockchain.id, address)
    # TODO: Update feed?
  end

  def handle_event(blockchain, %{"address" => address}, %Events.AnswerUpdated{} = event) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:ok, feed} ->
        updated_feed = %{feed | latest_answer: event.current}
        Chainlink.put_feed(updated_feed)

      {:error, :not_found} ->
        Chainlink.ensure_feed(blockchain.id, address)
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Events.NewTransmission{} = event) do
    case Chainlink.find_feed(blockchain.id, address) do
      {:ok, feed} ->
        updated_feed = %{
          feed
          | latest_answer: event.answer,
            latest_round: event.aggregator_round_id
        }

        Chainlink.put_feed(updated_feed)

      {:error, :not_found} ->
        Chainlink.ensure_feed(blockchain.id, address)
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Events.AvailableFundsUpdated{}) do
    Chainlink.ensure_feed(blockchain.id, address)
    # TODO: Update feed?
  end
end
