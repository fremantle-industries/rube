defmodule RubeWeb.BlockchainLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "new_head_received")
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)
      |> assign(latest_blocks: %{})

    {:ok, socket}
  end

  @impl true
  def handle_info({"new_head_received", blockchain_id, block_number}, socket) do
    latest_blocks =
      socket.assigns.latest_blocks
      |> Map.put(blockchain_id, block_number)

    {:noreply, assign(socket, latest_blocks: latest_blocks)}
  end

  @impl true
  def handle_event("start", %{"id" => blockchain_id}, socket) do
    Slurp.Commander.start_blockchains(where: [id: blockchain_id])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop", %{"id" => blockchain_id}, socket) do
    Slurp.Commander.stop_blockchains(where: [id: blockchain_id])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end

  @impl true
  def handle_event("start-all", _, socket) do
    Slurp.Commander.start_blockchains([])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop-all", _, socket) do
    Slurp.Commander.stop_blockchains([])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end
end
