defmodule Rube.Amm.EventHandler do
  alias Rube.Amm
  alias Rube.Amm.Events

  def handle_event(blockchain, %{"address" => address}, %Events.Swap{}) do
    case Amm.find_pair(blockchain.id, address) do
      {:ok, pair} ->
        # TODO: what attributes need to be updated here?
        # updated_pair = %{pair}
        updated_pair = pair
        Amm.put_pair(updated_pair)

      {:error, :not_found} ->
        Amm.ensure(blockchain.id, address)
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Events.Sync{} = event) do
    case Amm.find_pair(blockchain.id, address) do
      {:ok, pair} ->
        # updated_pair = %{
        #   pair
        #   | reserve0: event.reserve0,
        #     reserve1: event.reserve1
        #     # TODO: How can the k_last be set?
        #     # k_last: event.k_last,
        #     # price0_cumulative_last: event.price0_cumulative_last,
        #     # price1_cumulative_last: event.price1_cumulative_last
        # }

        updated_pair = pair
        Amm.put_pair(updated_pair)

      {:error, :not_found} ->
        Amm.ensure(blockchain.id, address)
    end
  end
end
