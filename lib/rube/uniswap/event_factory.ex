defmodule Rube.Uniswap.EventFactory do
  @type event_signature :: String.t()
  @type log_subscription_config :: %{
    enabled: boolean,
    struct: module,
    handler: mfa,
    abi: [map]
  }
  @type log_subscription_config_tuple :: {event_signature, [log_subscription_config]}
  @type opt :: {:swap_enabled, boolean} | {:sync_enabled, boolean}

  @spec create([opt]) :: [log_subscription_config_tuple]
  def create(opts) do
    [
      swap(enabled: get_opt(opts, :swap_enabled, true)),
      sync(enabled: get_opt(opts, :sync_enabled, true)),
    ]
  end

  @swap_event_signature "Swap(address,uint256,uint256,uint256,uint256,address)"
  @swap_struct Rube.Uniswap.Events.Swap
  defp swap(enabled: enabled) do
    abi = [
      swap_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @swap_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@swap_event_signature, handler_configs}
  end

  defp swap_abi do
      %{
        "anonymous" => false,
        "inputs" => [
          %{
            "indexed" => true,
            "name" => "sender",
            "type" => "address"
          },
          %{
            "indexed" => false,
            "name" => "amount0In",
            "type" => "uint256"
          },
          %{
            "indexed" => false,
            "name" => "amount1In",
            "type" => "uint256"
          },
          %{
            "indexed" => false,
            "name" => "amount0Out",
            "type" => "uint256"
          },
          %{
            "indexed" => false,
            "name" => "amount1Out",
            "type" => "uint256"
          },
          %{
            "indexed" => true,
            "name" => "to",
            "type" => "address"
          }
        ],
        "name" => "Swap",
        "type" => "event"
      }
  end

  @sync_event_signature "Sync(uint112,uint112)"
  @sync_struct Rube.Uniswap.Events.Sync
  defp sync(enabled: enabled) do
    abi = [
      sync_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @sync_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@sync_event_signature, handler_configs}
  end

  defp sync_abi do
      %{
        "anonymous" => false,
        "inputs" => [
          %{
            "indexed" => false,
            "name" => "reserve0",
            "type" => "uint112"
          },
          %{
            "indexed" => false,
            "name" => "reserve1",
            "type" => "uint112"
          }
        ],
        "name" => "Sync",
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
        # # AMM - Uniswap, Sushiswap, Pancakeswap etc...
        # "Sync(uint112,uint112)" => [
        #   %{
        #     enabled: true,
        #     struct: Rube.Amm.Events.Sync,
        #     handler: {Rube.EventHandler, :handle_event, []},
        #     abi: [
        #       %{
        #         "anonymous" => false,
        #         "inputs" => [
        #           %{
        #             "indexed" => false,
        #             "name" => "reserve0",
        #             "type" => "uint112"
        #           },
        #           %{
        #             "indexed" => false,
        #             "name" => "reserve1",
        #             "type" => "uint112"
        #           }
        #         ],
        #         "name" => "Sync",
        #         "type" => "event"
        #       }
        #     ]
        #   }
        # ],
