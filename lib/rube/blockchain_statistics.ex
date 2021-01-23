defmodule Rube.BlockchainStatistics do
  use GenServer

  defmodule State do
    defstruct ~w[last_head_received_at new_heads_received_total events_received_total started_at]a
  end

  defmodule Stats do
    defstruct ~w[last_head_received_at block_cadence_seconds events_per_second]a
  end

  def start_link(_) do
    state = %State{
      new_heads_received_total: 0,
      events_received_total: 0,
      started_at: System.monotonic_time()
    }

    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get do
    GenServer.call(__MODULE__, :get)
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :subscribe}}
  end

  @impl true
  def handle_continue(:subscribe, state) do
    Phoenix.PubSub.subscribe(Rube.PubSub, "heads:new_head_received")
    Phoenix.PubSub.subscribe(Rube.PubSub, "events:event_received")
    {:noreply, state}
  end

  @impl true
  def handle_continue(:publish_new_stats, state) do
    Phoenix.PubSub.broadcast(
      Rube.PubSub,
      "blockchain_statistics:new_stats",
      {"blockchain_statistics:new_stats", build_stats(state)}
    )

    {:noreply, state}
  end

  @impl true
  def handle_info({"heads:new_head_received", _blockchain_id, _block_number}, state) do
    state = %{
      state
      | last_head_received_at: System.monotonic_time(),
        new_heads_received_total: state.new_heads_received_total + 1
    }

    {:noreply, state, {:continue, :publish_new_stats}}
  end

  @impl true
  def handle_info(
        {"events:event_received", _blockchain_id, _block_number, _block_hash, _address, _event},
        state
      ) do
    state = %{state | events_received_total: state.events_received_total + 1}
    {:noreply, state, {:continue, :publish_new_stats}}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, build_stats(state), state}
  end

  defp build_stats(state) do
    %Stats{
      last_head_received_at: state.last_head_received_at,
      block_cadence_seconds: block_cadence_seconds(state),
      events_per_second: events_per_second(state)
    }
  end

  defp block_cadence_seconds(%State{new_heads_received_total: 0}), do: 0

  defp block_cadence_seconds(state) do
    now = System.monotonic_time()

    seconds_passed =
      System.convert_time_unit(now - state.started_at, :native, :millisecond) / 1000

    Float.round(seconds_passed / state.new_heads_received_total, 2)
  end

  defp events_per_second(%State{events_received_total: 0}), do: 0

  defp events_per_second(state) do
    now = System.monotonic_time()

    seconds_passed =
      System.convert_time_unit(now - state.started_at, :native, :millisecond) / 1000

    Float.round(state.events_received_total / seconds_passed, 2)
  end
end
