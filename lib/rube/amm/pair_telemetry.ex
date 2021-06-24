defmodule Rube.Amm.PairTelemetry do
  use GenServer
  alias Rube.Amm

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(state) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_pair")
    {:ok, state}
  end

  @impl true
  def handle_info({"after_put_pair", pair}, state) do
    execute_price_metric(pair)
    execute_reserve0_metric(pair)
    execute_reserve1_metric(pair)
    {:noreply, state}
  end

  defp execute_price_metric(pair) do
    price = Amm.Pair.price(pair)

    :telemetry.execute(
      [:rube, :amm, :pair_price],
      %{price: price |> Decimal.to_float()},
      %{
        blockchain_id: pair.blockchain_id,
        address: pair.address,
        token0_address: pair.token0,
        token0_symbol: pair.token0_symbol,
        token1_address: pair.token1,
        token1_symbol: pair.token1_symbol
      }
    )
  end

  defp execute_reserve0_metric(pair) do
    :telemetry.execute(
      [:rube, :amm, :pair_reserve0],
      %{reserve: pair.reserve0},
      %{
        blockchain_id: pair.blockchain_id,
        address: pair.address,
        token_address: pair.token0,
        token_symbol: pair.token0_symbol
      }
    )
  end

  defp execute_reserve1_metric(pair) do
    :telemetry.execute(
      [:rube, :amm, :pair_reserve1],
      %{reserve: pair.reserve1},
      %{
        blockchain_id: pair.blockchain_id,
        address: pair.address,
        token_address: pair.token1,
        token_symbol: pair.token1_symbol
      }
    )
  end
end
