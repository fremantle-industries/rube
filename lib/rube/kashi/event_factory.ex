defmodule Rube.Kashi.EventFactory do
  @moduledoc """
  SushiSwap Kashi Lending

  https://docs.sushi.com/products/kashi-lending
  """

  @type event_signature :: String.t()
  @type log_subscription_config :: %{
    enabled: boolean,
    struct: module,
    handler: mfa,
    abi: [map]
  }
  @type log_subscription_config_tuple :: {event_signature, [log_subscription_config]}
  @type opt :: {:accrue_interest_enabled, boolean}

  @spec create([opt]) :: [log_subscription_config_tuple]
  def create(opts) do
    [
      log_accrue(enabled: get_opt(opts, :log_accrue_enabled, true))
    ]
  end

  @log_accrue_event_signature "LogAccrue(uint256,uint256,uint64,uint256)"
  @log_accrue_struct Rube.Kashi.Events.LogAccrue
  defp log_accrue(enabled: enabled) do
    abi = [
      log_accrue_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @log_accrue_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@log_accrue_event_signature, handler_configs}
  end

  defp log_accrue_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "accruedAmount",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "feeFraction",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint64",
          "name" => "rate",
          "type" => "uint64"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "utilization",
          "type" => "uint256"
        },
      ],
      "name" => "LogAccrue",
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
