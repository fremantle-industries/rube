defmodule Rube.Chainlink.FeedTelemetry do
  use GenServer
  alias Rube.Chainlink

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_feed")
    {:ok, state}
  end

  @impl true
  def handle_info({"after_put_feed", feed}, state) do
    execute_price_metric(feed)
    {:noreply, state}
  end

  defp execute_price_metric(feed) do
    latest_answer = feed |> Chainlink.Feed.humanize_latest_answer() |> Decimal.to_float()

    :telemetry.execute(
      [:rube, :chainlink, :feeds],
      %{
        latest_answer: latest_answer,
        latest_round: feed.latest_round
      },
      %{
        blockchain_id: feed.blockchain_id,
        address: feed.address,
        name: feed.name
      }
    )
  end
end
