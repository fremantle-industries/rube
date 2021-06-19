defmodule Rube.EventHandler do
  require Logger

  def handle_event(
        blockchain,
        %{"blockNumber" => hex_block_number, "blockHash" => block_hash, "address" => address} =
          log,
        event
      ) do
    {:ok, block_number} = Slurp.Utils.hex_to_integer(hex_block_number)
    route_event(blockchain, log, event)

    Phoenix.PubSub.broadcast(
      Slurpee.PubSub,
      "events:event_received",
      {"events:event_received", blockchain.id, block_number, block_hash, address, event}
    )
  end

  defp route_event(blockchain, log, %event_name{} = event)
       when event_name == Rube.Erc20.Events.Transfer or
              event_name == Rube.Erc20.Events.Mint or
              event_name == Rube.Erc20.Events.Burn do
    Rube.Erc20.EventHandler.handle_event(blockchain, log, event)
  end

  defp route_event(blockchain, log, %Rube.Amm.Events.Swap{} = event) do
    Rube.Amm.EventHandler.handle_event(blockchain, log, event)
  end

  defp route_event(blockchain, log, %event_name{} = event)
       when event_name == Rube.Chainlink.Events.AnswerUpdated or
              event_name == Rube.Chainlink.Events.NewRound or
              event_name == Rube.Chainlink.Events.SubmissionReceived or
              event_name == Rube.Chainlink.Events.NewTransmission do
    Rube.Chainlink.EventHandler.handle_event(blockchain, log, event)
  end

  defp route_event(blockchain, log, %event_name{} = event)
       when event_name == Rube.MoneyMarkets.Events.AccrueInterest do
    Rube.MoneyMarkets.EventHandler.handle_event(blockchain, log, event)
  end

  defp route_event(_, _, %event_name{} = _) do
    Logger.warn("received unhandled event: #{event_name}")
  end
end
