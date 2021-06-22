defmodule RubeWeb.MoneyMarketLive do
  use RubeWeb, :live_view
  import SlurpeeWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]
  import RubeWeb.ExplorerHelpers, only: [explorer_address_link: 3]
  import Stylish.Ellipsis, only: [ellipsis: 2]
  import Stylish.CopyButton, only: [copy_button: 1]

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_money_market")

    socket =
      socket
      |> assign(:query, nil)
      |> assign(latest_money_market: nil)

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
  def handle_info({"after_put_money_market", latest_money_market}, socket) do
    socket =
      socket
      |> assign_search()
      |> assign(latest_money_market: latest_money_market)

    {:noreply, socket}
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
    |> assign(money_markets: search_money_markets(socket.assigns.query))
  end

  @order_by ~w[blockchain_id symbol]a
  defp search_money_markets(search_term) do
    Rube.MoneyMarkets.all()
    |> Enumerati.order(@order_by)
    |> search_money_markets(search_term)
  end

  defp search_money_markets(money_markets, nil) do
    money_markets
  end

  defp search_money_markets(money_markets, search_term) do
    money_markets
    |> Enum.filter(fn t ->
      String.contains?(t.blockchain_id, search_term) ||
        String.contains?(t.symbol, search_term) ||
        String.contains?(t.address, search_term)
    end)
  end
end
