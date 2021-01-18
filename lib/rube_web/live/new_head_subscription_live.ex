defmodule RubeWeb.NewHeadSubscriptionLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    new_head_subscriptions = Slurp.Commander.new_head_subscriptions([])

    socket =
      socket
      |> assign(new_head_subscriptions: new_head_subscriptions)

    {:ok, socket}
  end
end
