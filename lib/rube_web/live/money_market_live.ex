defmodule RubeWeb.MoneyMarketLive do
  use RubeWeb, :live_view

  @order_by ~w[blockchain_id symbol]a

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "after_put_money_market")

    money_markets =
      Rube.MoneyMarkets.all()
      |> Enumerati.order(@order_by)

    socket =
      socket
      |> assign(money_markets: money_markets)
      |> assign(latest_money_market: nil)

    {:ok, socket}
  end

  @impl true
  def handle_info({"after_put_money_market", latest_money_market}, socket) do
    money_markets =
      Rube.Tokens.all()
      |> Enumerati.order(@order_by)

    socket =
      socket
      |> assign(money_markets: money_markets)
      |> assign(latest_money_market: latest_money_market)

    {:noreply, socket}
  end
end
