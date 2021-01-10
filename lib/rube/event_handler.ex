defmodule Rube.EventHandler do
  require Logger

  def handle_event(
        blockchain,
        %{"blockNumber" => hex_block_number, "blockHash" => block_hash, "address" => address},
        event
      ) do
    {:ok, block_number} = Slurp.Utils.hex_to_integer(hex_block_number)

    Logger.debug(
      "received event: #{inspect(event)}, block_number: #{block_number}, block_hash: #{block_hash}, address: #{
        address
      }"
    )

    Phoenix.PubSub.broadcast(
      Rube.PubSub,
      "event_received",
      {"event_received", blockchain.id, block_number, block_hash, address, event}
    )
  end
end
