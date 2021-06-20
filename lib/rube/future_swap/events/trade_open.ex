defmodule Rube.FutureSwap.Events.TradeOpen do
  defstruct ~w[
    trade_id
    trade_owner
    is_long
    collateral
    leverage
    asset_price
    stable_price
    open_fee
    oracle_round_id
    timestamp
    referral
  ]a
end
