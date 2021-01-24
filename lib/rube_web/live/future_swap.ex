defmodule RubeWeb.FutureSwapLive do
  use RubeWeb, :live_view

  @order_by ~w[blockchain_id token_0 token_1]a

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "after_put_pair")

    pairs =
      Rube.Amm.pairs()
      |> Enumerati.order(@order_by)

    socket =
      socket
      |> assign(pairs: pairs)
      |> assign(latest_pair: nil)

    {:ok, socket}
  end

  @impl true
  def handle_info({"after_put_pair", latest_pair}, socket) do
    pairs =
      Rube.Amm.pairs()
      |> Enumerati.order(@order_by)

    socket =
      socket
      |> assign(pairs: pairs)
      |> assign(latest_pair: latest_pair)

    {:noreply, socket}
  end

  defp format_address(value) when is_binary(value) and byte_size(value) == 20 do
    value |> Base.encode16(case: :lower) |> ExW3.Utils.to_checksum_address()
  end
end
