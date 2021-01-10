defmodule Rube.NewHeadHandler do
  require Logger

  def handle_new_head(blockchain, block_number) do
    Logger.info("received new head: #{block_number}")

    Phoenix.PubSub.broadcast(
      Rube.PubSub,
      "new_head_received",
      {"new_head_received", blockchain.id, block_number}
    )
  end
end
