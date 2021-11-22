defmodule Rube.Erc20.EventFactory do
  @type event_signature :: String.t()
  @type log_subscription_config :: %{
    enabled: boolean,
    struct: module,
    handler: mfa,
    abi: [map]
  }
  @type log_subscription_config_tuple :: {event_signature, [log_subscription_config]}
  @type opt :: {:approval_enabled, boolean} | {:transfer_enabled, boolean}

  @spec create([opt]) :: [log_subscription_config_tuple]
  def create(opts) do
    [
      approval(enabled: get_opt(opts, :approval_enabled, true)),
      transfer(enabled: get_opt(opts, :transfer_enabled, true)),
    ]
  end

  @approval_event_signature "Approval(address,address,uint256)"
  @approval_struct Rube.Erc20.Events.Approval
  defp approval(enabled: enabled) do
    abi = [
      approval_abi(),                 # token standard
      approval_abi(index_value: true) # fallback
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @approval_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@approval_event_signature, handler_configs}
  end

  defp approval_abi(indexes \\ [index_value: false]) do
    index_value = Keyword.get(indexes, :index_value) || false

    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "name" => "owner",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "name" => "spender",
          "type" => "address"
        },
        %{
          "indexed" => index_value,
          "name" => "value",
          "type" => "uint256"
        }
      ],
      "name" => "Approval",
      "type" => "event"
    }
  end

  @transfer_event_signature "Transfer(address,address,uint256)"
  @transfer_struct Rube.Erc20.Events.Transfer
  defp transfer(enabled: enabled) do
    abi = [
      transfer_abi(),                 # token standard
      transfer_abi(index_value: true) # fallback
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @transfer_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@transfer_event_signature, handler_configs}
  end

  defp transfer_abi(indexes \\ [index_value: false]) do
    index_value = Keyword.get(indexes, :index_value) || false

    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "name" => "from",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "name" => "to",
          "type" => "address"
        },
        %{
          "indexed" => index_value,
          "name" => "value",
          "type" => "uint256"
        }
      ],
      "name" => "Transfer",
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
