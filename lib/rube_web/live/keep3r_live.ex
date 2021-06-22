defmodule RubeWeb.Keep3rLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    jobs = []

    socket =
      socket
      |> assign(jobs: jobs)

    {:ok, socket}
  end
end
