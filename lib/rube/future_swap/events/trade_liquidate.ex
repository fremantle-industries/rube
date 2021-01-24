defmodule Rube.FutureSwap.Events.TradeLiquidate do
  defstruct ~w[
    trade_id
    trade_owner
    liquidator
    stable_to_send_liquidator
    stable_to_send_trade_owner
    timestamp
  ]a
end
