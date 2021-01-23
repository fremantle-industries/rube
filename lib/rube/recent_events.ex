defmodule Rube.RecentEvents do
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
    {:ok, state, {:continue, :receive_events}}
  end

  @impl true
  def handle_continue(:receive_events, state) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "events:event_received")
    {:noreply, state}
  end

  @impl true
  def handle_continue(:publish_recent_event_received, state) do
    Phoenix.PubSub.broadcast(
      Rube.PubSub,
      "recent_events:event_received",
      {"recent_events:event_received", state}
    )

    {:noreply, state}
  end

  @impl true
  def handle_info(
        {"events:event_received", blockchain_id, block_number, block_hash, address, event},
        state
      ) do
    state =
      state
      |> Deque.appendleft({blockchain_id, block_number, block_hash, address, event})

    {:noreply, state, {:continue, :publish_recent_event_received}}
  end

  @impl true
  def handle_call(:queue, _from, state) do
    {:reply, state, state}
  end
end
