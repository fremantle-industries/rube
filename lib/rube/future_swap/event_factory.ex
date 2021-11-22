defmodule Rube.FutureSwap.EventFactory do
  @type event_signature :: String.t()
  @type log_subscription_config :: %{
    enabled: boolean,
    struct: module,
    handler: mfa,
    abi: [map]
  }
  @type log_subscription_config_tuple :: {event_signature, [log_subscription_config]}
  @type opt :: {:trade_open_enabled, boolean} | {:trade_liquidate_enabled, boolean}

  @spec create([opt]) :: [log_subscription_config_tuple]
  def create(opts) do
    [
      trade_open(enabled: get_opt(opts, :trade_open_enabled, true)),
      trade_liquidate(enabled: get_opt(opts, :trade_liquidate_enabled, true)),
    ]
  end

  @trade_open_event_signature "TradeOpen(uint256,address,bool,uint256,uint256,uint256,uint256,uint256,uint256,uint256,address)"
  @trade_open_struct Rube.FutureSwap.Events.TradeOpen
  defp trade_open(enabled: enabled) do
    abi = [
      trade_open_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @trade_open_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@trade_open_event_signature, handler_configs}
  end

  defp trade_open_abi do
        %{
          "anonymous" => false,
          "inputs" => [
            %{
              "indexed" => true,
              "internalType" => "uint256",
              "name" => "tradeId",
              "type" => "uint256"
            },
            %{
              "indexed" => true,
              "internalType" => "address",
              "name" => "tradeOwner",
              "type" => "address"
            },
            %{
              "indexed" => false,
              "internalType" => "bool",
              "name" => "isLong",
              "type" => "bool"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "collateral",
              "type" => "uint256"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "leverage",
              "type" => "uint256"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "assetPrice",
              "type" => "uint256"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "stablePrice",
              "type" => "uint256"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "openFee",
              "type" => "uint256"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "oracleRoundId",
              "type" => "uint256"
            },
            %{
              "indexed" => false,
              "internalType" => "uint256",
              "name" => "timestamp",
              "type" => "uint256"
            },
            %{
              "indexed" => true,
              "internalType" => "address",
              "name" => "referral",
              "type" => "address"
            }
          ],
          "name" => "TradeOpen",
          "type" => "event"
        }
  end

  @trade_liquidate_event_signature "TradeLiquidate(uint256,address,address,uint256,uint256,uint256)"
  @trade_liquidate_struct Rube.FutureSwap.Events.TradeLiquidate
  defp trade_liquidate(enabled: enabled) do
    abi = [
      trade_liquidate_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @trade_liquidate_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@trade_liquidate_event_signature, handler_configs}
  end

  defp trade_liquidate_abi do
      %{
        "anonymous" => false,
        "inputs" => [
          %{
            "indexed" => true,
            "internalType" => "uint256",
            "name" => "tradeId",
            "type" => "uint256"
          },
          %{
            "indexed" => true,
            "internalType" => "address",
            "name" => "tradeOwner",
            "type" => "address"
          },
          %{
            "indexed" => true,
            "internalType" => "address",
            "name" => "liquidator",
            "type" => "address"
          },
          %{
            "indexed" => false,
            "internalType" => "uint256",
            "name" => "stableToSendLiquidator",
            "type" => "uint256"
          },
          %{
            "indexed" => false,
            "internalType" => "uint256",
            "name" => "stableToSendTradeOwner",
            "type" => "uint256"
          },
          %{
            "indexed" => false,
            "internalType" => "uint256",
            "name" => "timestamp",
            "type" => "uint256"
          }
        ],
        "name" => "TradeLiquidate",
        "type" => "event"
      }
  end

  defp get_opt(opts, name, default) do
    Keyword.get(opts, name, default)
  end

  defp handler_config(enabled: enabled, struct: struct, abi: abi, handler: handler) do
    %{
      enabled: enabled,
      struct: struct,
      handler: handler,
      abi: abi
    }
  end
end
