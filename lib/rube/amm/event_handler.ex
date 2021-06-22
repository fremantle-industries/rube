defmodule Rube.Amm.EventHandler do
  alias Rube.Amm
  alias Rube.Amm.Events

  def handle_event(blockchain, %{"address" => address}, %Events.Swap{}) do
    Amm.get_or_fetch_pair(blockchain.id, address)
  end

  def handle_event(blockchain, %{"address" => address}, %Events.Sync{} = event) do
    case Amm.find_pair(blockchain.id, address) do
      {:ok, pair} ->
        updated_pair = %{pair | reserve0: event.reserve0, reserve1: event.reserve1}
        Amm.put_pair(updated_pair)

      {:error, :not_found} ->
        Amm.PairIndexer.get_or_fetch_pair(blockchain.id, address)
    end
  end
end
