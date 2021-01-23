defmodule RubeWeb.HomeLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "events:event_received")
    Phoenix.PubSub.subscribe(Rube.PubSub, "recent_heads:new_head_received")
    Phoenix.PubSub.subscribe(Rube.PubSub, "blockchain_statistics:new_stats")
    stats = Rube.BlockchainStatistics.get()

    socket =
      socket
      |> assign(last_head_received_at: stats.last_head_received_at)
      |> assign(block_cadence_seconds: stats.block_cadence_seconds)
      |> assign(events_per_second: stats.events_per_second)
      |> assign(recent_blocks: Rube.RecentHeads.queue())
      |> assign(recent_events: Rube.RecentEvents.queue())

    {:ok, socket}
  end

  @impl true
  def handle_info(
        {"events:event_received", blockchain_id, block_number, block_hash, address, event},
        socket
      ) do
    recent_events =
      socket.assigns.recent_events
      |> Deque.appendleft({blockchain_id, block_number, block_hash, address, event})

    socket =
      socket
      |> assign(recent_events: recent_events)

    {:noreply, socket}
  end

  @impl true
  def handle_info({"recent_heads:new_head_received", recent_heads}, socket) do
    socket =
      socket
      |> assign(recent_blocks: recent_heads)

    {:noreply, socket}
  end

  @impl true
  def handle_info(
        {"blockchain_statistics:new_stats", stats},
        socket
      ) do
    socket =
      socket
      |> assign(last_head_received_at: stats.last_head_received_at)
      |> assign(block_cadence_seconds: stats.block_cadence_seconds)
      |> assign(events_per_second: stats.events_per_second)

    {:noreply, socket}
  end

  defp last_head_received_at(nil), do: nil

  defp last_head_received_at(received_at) when is_integer(received_at) do
    received_latency =
      System.convert_time_unit(System.monotonic_time() - received_at, :native, :millisecond)

    unix_now = "Etc/UTC" |> DateTime.now!() |> DateTime.to_unix(:millisecond)
    unix_now - received_latency
  end

  defp format_event_attr(value) when is_binary(value) and byte_size(value) == 20 do
    value |> Base.encode16(case: :lower) |> ExW3.Utils.to_checksum_address()
  end

  defp format_event_attr(value), do: value |> inspect
end
