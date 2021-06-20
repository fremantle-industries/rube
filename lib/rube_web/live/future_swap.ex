defmodule RubeWeb.FutureSwapLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(pairs: [])
      |> assign(latest: nil)

    {:ok, socket}
  end
end
