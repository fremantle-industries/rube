defmodule RubeWeb.AlertLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    alerts = []

    socket =
      socket
      |> assign(alerts: alerts)

    {:ok, socket}
  end
end
