defmodule Rube.Amm.EventHandler do
  require Logger

  def handle_event(blockchain, %{"address" => address}, %Rube.Amm.Events.Swap{}) do
    case Rube.Amm.find_pair(blockchain.id, address) do
      {:error, :not_found} ->
        Rube.Amm.fetch_and_store_pair(blockchain.id, address)

      _ ->
        nil
    end
  end
end
