defmodule RubeWeb.ChainlinkLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_feed")

    feeds =
      Rube.Chainlink.feeds()
      |> Enumerati.order([:blockchain_id, :name, :type])

    socket =
      socket
      |> assign(feeds: feeds)
      |> assign(latest_feed: nil)

    {:ok, socket}
  end

  @impl true
  def handle_info({"after_put_feed", latest_feed}, socket) do
    feeds =
      Rube.Chainlink.feeds()
      |> Enumerati.order([:blockchain_id, :name, :type])

    socket =
      socket
      |> assign(feeds: feeds)
      |> assign(latest_feed: latest_feed)

    {:noreply, socket}
  end

  defp humanize_latest_answer(feed) do
    divisor = 10 |> :math.pow(feed.precision) |> Decimal.from_float()
    latest_answer = Decimal.new(feed.latest_answer)
    latest_answer |> Decimal.div(divisor) |> Decimal.normalize() |> Decimal.to_string(:normal)
  end
end
