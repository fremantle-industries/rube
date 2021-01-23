defmodule Rube.RecentHeads do
  use GenServer

  def start_link(_) do
    queue = Deque.new(100)
    GenServer.start_link(__MODULE__, queue, name: __MODULE__)
  end

  def queue do
    GenServer.call(__MODULE__, :queue)
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :subscribe_new_heads}}
  end

  @impl true
  def handle_continue(:subscribe_new_heads, state) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "heads:new_head_received")
    {:noreply, state}
  end

  @impl true
  def handle_continue(:publish_recent_head_received, state) do
    Phoenix.PubSub.broadcast(
      Rube.PubSub,
      "recent_heads:new_head_received",
      {"recent_heads:new_head_received", state}
    )

    {:noreply, state}
  end

  @impl true
  def handle_info({"heads:new_head_received", blockchain_id, block_number}, state) do
    state =
      state
      |> Deque.appendleft({blockchain_id, block_number})

    {:noreply, state, {:continue, :publish_recent_head_received}}
  end

  @impl true
  def handle_call(:queue, _from, state) do
    {:reply, state, state}
  end
end
