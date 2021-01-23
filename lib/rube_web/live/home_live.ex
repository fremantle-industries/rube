defmodule RubeWeb.HomeLive do
  use RubeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "events:event_received")
    Phoenix.PubSub.subscribe(Rube.PubSub, "heads:new_head_received")
    Phoenix.PubSub.subscribe(Rube.PubSub, "recent_heads:new_head_received")

    socket =
      socket
      |> assign(initial_block_number: nil)
      |> assign(last_block_number: nil)
      |> assign(last_block_received_at: nil)
      |> assign(total_events: 0)
      |> assign(last_event_received_at: nil)
      |> assign(mounted_at: System.monotonic_time())
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
      |> assign(total_events: socket.assigns.total_events + 1)
      |> assign(recent_events: recent_events)

    {:noreply, socket}
  end

  @impl true
  def handle_info({"heads:new_head_received", _blockchain_id, block_number}, socket) do
    socket =
      socket
      |> assign(initial_block_number: socket.assigns.initial_block_number || block_number)
      |> assign(last_block_number: block_number)
      |> assign(last_block_received_at: System.monotonic_time())

    {:noreply, socket}
  end

  @impl true
  def handle_info({"recent_heads:new_head_received", recent_heads}, socket) do
    socket =
      socket
      |> assign(recent_blocks: recent_heads)

    {:noreply, socket}
  end

  defp last_block_received_at(nil), do: nil

  defp last_block_received_at(received_at) when is_integer(received_at) do
    received_latency =
      System.convert_time_unit(System.monotonic_time() - received_at, :native, :millisecond)

    unix_now = "Etc/UTC" |> DateTime.now!() |> DateTime.to_unix(:millisecond)
    unix_now - received_latency
  end

  defp block_cadence_seconds(nil, nil, _), do: 0

  defp block_cadence_seconds(last, initial, mounted_at) when last == initial,
    do: block_cadence_seconds(last, last - 1, mounted_at)

  defp block_cadence_seconds(last, initial, mounted_at) do
    now = System.monotonic_time()
    seconds_passed = System.convert_time_unit(now - mounted_at, :native, :millisecond) / 1000
    total_blocks = last - initial

    Float.round(seconds_passed / total_blocks, 2)
  end

  defp events_per_second(0, _), do: 0

  defp events_per_second(total_events, mounted_at) do
    now = System.monotonic_time()
    seconds_passed = System.convert_time_unit(now - mounted_at, :native, :millisecond) / 1000
    Float.round(seconds_passed / total_events, 2)
  end

  defp format_event_attr(value) when is_binary(value) and byte_size(value) == 20 do
    value |> Base.encode16(case: :lower) |> ExW3.Utils.to_checksum_address()
  end

  defp format_event_attr(value), do: value |> inspect
end
