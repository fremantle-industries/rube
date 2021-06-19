defmodule RubeWeb.TokenLive do
  use RubeWeb, :live_view

  @order_by ~w[blockchain_id symbol]a

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_token")

    tokens =
      Rube.Tokens.all()
      |> Enumerati.order(@order_by)

    socket =
      socket
      |> assign(tokens: tokens)
      |> assign(latest_token: nil)

    {:ok, socket}
  end

  @impl true
  def handle_info({"after_put_token", latest_token}, socket) do
    tokens =
      Rube.Tokens.all()
      |> Enumerati.order(@order_by)

    socket =
      socket
      |> assign(tokens: tokens)
      |> assign(latest_token: latest_token)

    {:noreply, socket}
  end
end
