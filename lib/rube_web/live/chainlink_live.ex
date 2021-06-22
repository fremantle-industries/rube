defmodule RubeWeb.ChainlinkLive do
  use RubeWeb, :live_view
  import SlurpeeWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]
  import RubeWeb.ExplorerHelpers, only: [explorer_address_link: 3]
  import Stylish.Ellipsis, only: [ellipsis: 2]
  import Stylish.CopyButton, only: [copy_button: 1]

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_feed")

    socket =
      socket
      |> assign(:query, nil)
      |> assign(latest: nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_search()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> send_search_after(200)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:search, socket) do
    socket =
      socket
      |> assign(:search_timer, nil)
      |> assign_search()

    {:noreply, socket}
  end

  @impl true
  def handle_info({"after_put_feed", latest_feed}, socket) do
    socket =
      socket
      |> assign_search()
      |> send_clear_latest(3000)
      |> assign(latest: latest_feed)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:clear_latest, socket) do
    socket =
      socket
      |> assign(:latest, nil)

    {:noreply, socket}
  end

  @timer_name :clear_latest_timer
  defp send_clear_latest(socket, after_ms) do
    if socket.assigns[@timer_name] do
      Process.cancel_timer(socket.assigns[@timer_name])
    end

    timer = Process.send_after(self(), :clear_latest, after_ms)

    socket
    |> assign(@timer_name, timer)
  end

  defp send_search_after(socket, after_ms) do
    if socket.assigns[:search_timer] do
      socket
    else
      timer = Process.send_after(self(), :search, after_ms)
      assign(socket, :search_timer, timer)
    end
  end

  defp assign_search(socket) do
    socket
    |> assign(feeds: search_feeds(socket.assigns.query))
  end

  @order_by ~w[blockchain_id name type]a
  defp search_feeds(search_term) do
    Rube.Chainlink.feeds()
    |> Enumerati.order(@order_by)
    |> search_feeds(search_term)
  end

  defp search_feeds(tokens, nil) do
    tokens
  end

  defp search_feeds(tokens, search_term) do
    tokens
    |> Enum.filter(fn t ->
      String.contains?(t.blockchain_id, search_term) ||
        String.contains?(t.name, search_term) ||
        String.contains?(t.address, search_term) ||
        String.contains?(t.enabled |> to_string(), search_term) ||
        String.contains?(t.type |> Atom.to_string(), search_term)
    end)
  end

  defp humanize_latest_answer(feed) do
    divisor = 10 |> :math.pow(feed.precision) |> Decimal.from_float()
    latest_answer = Decimal.new(feed.latest_answer)
    latest_answer |> Decimal.div(divisor) |> Decimal.normalize() |> Decimal.to_string(:normal)
  end
end
