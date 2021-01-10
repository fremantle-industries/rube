defmodule RubeWeb.UniswapLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # Phoenix.PubSub.subscribe(Rube.PubSub, "new_head_received")
    # blockchains = Slurp.Blockchains.all()

    socket = socket
    # |> assign(blockchains: blockchains)
    # |> assign(latest_blocks: %{})

    {:ok, socket}
  end

  # @impl true
  # def handle_info({"new_head_received", blockchain_id, block_number}, socket) do
  #   latest_blocks =
  #     socket.assigns.latest_blocks
  #     |> Map.put(blockchain_id, block_number)

  #   {:noreply, assign(socket, latest_blocks: latest_blocks)}
  # end

  # def latest_block(latest_blocks, blockchain_id), do: Map.get(latest_blocks, blockchain_id, "-")
end
