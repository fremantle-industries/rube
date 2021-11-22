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

  @erc20_events [
    Rube.Erc20.Events.Approval,
    Rube.Erc20.Events.Transfer
  ]
  defp route_event(blockchain, log, %event_name{} = event)
       when event_name in @erc20_events do
    Rube.Erc20.EventHandler.handle_event(blockchain, log, event)
  end

  @amm_events [
    Rube.Uniswap.Events.Sync,
    Rube.Uniswap.Events.Swap
  ]
  defp route_event(blockchain, log, %event_name{} = event) when event_name in @amm_events do
    Rube.Amm.EventHandler.handle_event(blockchain, log, event)
  end

  @chainlink_events [
    Rube.Chainlink.Events.AnswerUpdated,
    Rube.Chainlink.Events.NewRound,
    Rube.Chainlink.Events.SubmissionReceived,
    Rube.Chainlink.Events.NewTransmission,
    Rube.Chainlink.Events.AvailableFundsUpdated
  ]
  defp route_event(blockchain, log, %event_name{} = event)
       when event_name in @chainlink_events do
    Rube.Chainlink.EventHandler.handle_event(blockchain, log, event)
  end

  @money_market_events [
    Rube.Compound.Events.AccrueInterest,
    Rube.Compound.Events.Borrow,
    Rube.Compound.Events.Redeem,
    Rube.Compound.Events.RepayBorrow,
    Rube.Compound.Events.LiquidateBorrow
  ]
  defp route_event(blockchain, log, %event_name{} = event)
       when event_name in @money_market_events do
    Rube.MoneyMarkets.EventHandler.handle_event(blockchain, log, event)
  end

  defp route_event(_, _, %event_name{} = _) do
    Logger.warn("received unhandled event: #{event_name}")
  end
end
