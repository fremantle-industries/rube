defmodule RubeWeb.LogSubscriptionLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    log_subscriptions = Slurp.Commander.log_subscriptions([])

    socket =
      socket
      |> assign(log_subscriptions: log_subscriptions)

    {:ok, socket}
  end
end
