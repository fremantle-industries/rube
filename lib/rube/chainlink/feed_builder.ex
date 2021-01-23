defmodule Rube.Chainlink.FeedBuilder do
  use GenServer
  alias Rube.Chainlink

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def fetch(blockchain_id, address) do
    GenServer.cast(__MODULE__, {:fetch, blockchain_id, address})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:fetch, blockchain_id, address}, state) do
    with {:ok, feed} <- fetch_feed(blockchain_id, address) do
      {:ok, _} = Chainlink.FeedStore.put(feed)
    end

    {:noreply, state}
  end

  defp fetch_feed(blockchain_id, address) do
    with {:ok, blockchain} <- Slurp.Blockchains.find(blockchain_id),
         {:ok, description} <- Chainlink.FeedContract.description(blockchain, address),
         {:ok, version} <- Chainlink.FeedContract.version(blockchain, address),
         {:ok, enabled} <- Chainlink.FeedContract.check_enabled(blockchain, address),
         {:ok, decimals} <- Chainlink.FeedContract.decimals(blockchain, address),
         {:ok, latest_answer} <- Chainlink.FeedContract.latest_answer(blockchain, address),
         {:ok, latest_round} <- Chainlink.FeedContract.latest_round(blockchain, address),
         type <- version_to_feed_type(version) do
      feed = %Chainlink.Feed{
        blockchain_id: blockchain_id,
        address: address,
        name: description,
        type: type,
        enabled: enabled,
        precision: decimals,
        latest_answer: latest_answer,
        latest_round: latest_round
      }

      {:ok, feed}
    end
  end

  defp version_to_feed_type(2), do: :deviator_aggregator
  defp version_to_feed_type(3), do: :flux_aggregator
  defp version_to_feed_type(4), do: :offchain_aggregator
  defp version_to_feed_type(_), do: :unknown
end
