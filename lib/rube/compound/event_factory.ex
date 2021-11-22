defmodule Rube.Compound.EventFactory do
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
      accrue_interest(enabled: get_opt(opts, :accrue_interest_enabled, true)),
      redeem(enabled: get_opt(opts, :redeem_enabled, true)),
      borrow(enabled: get_opt(opts, :borrow_enabled, true)),
      repay_borrow(enabled: get_opt(opts, :repay_borrow_enabled, true)),
      liquidate_borrow(enabled: get_opt(opts, :liquidate_borrow_enabled, true))
    ]
  end

  @accrue_interest_event_signature "AccrueInterest(uint256,uint256,uint256,uint256)"
  @accrue_interest_struct Rube.Compound.Events.AccrueInterest
  defp accrue_interest(enabled: enabled) do
    abi = [
      accrue_interest_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @accrue_interest_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@accrue_interest_event_signature, handler_configs}
  end

  defp accrue_interest_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "cashPrior",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "interestAccumulated",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "borrowIndex",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "totalBorrows",
          "type" => "uint256"
        }
      ],
      "name" => "AccrueInterest",
      "type" => "event"
    }
  end

  @redeem_event_signature "Redeem(address,uint256,uint256)"
  @redeem_struct Rube.Compound.Events.Redeem
  defp redeem(enabled: enabled) do
    abi = [
      redeem_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @redeem_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@redeem_event_signature, handler_configs}
  end

  defp redeem_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "redeemer",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "redeemAmount",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "redeemTokens",
          "type" => "uint256"
        }
      ],
      "name" => "Redeem",
      "type" => "event"
    }
  end

  @borrow_event_signature "Borrow(address,uint256,uint256,uint256)"
  @borrow_struct Rube.Compound.Events.Borrow
  defp borrow(enabled: enabled) do
    abi = [
      borrow_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @borrow_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@borrow_event_signature, handler_configs}
  end

  defp borrow_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "borrower",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "borrowAmount",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "accountBorrows",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "totalBorrows",
          "type" => "uint256"
        }
      ],
      "name" => "Borrow",
      "type" => "event"
    }
  end

  @repay_borrow_event_signature "RepayBorrow(address,address,uint256,uint256,uint256)"
  @repay_borrow_struct Rube.Compound.Events.RepayBorrow
  defp repay_borrow(enabled: enabled) do
    abi = [
      repay_borrow_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @repay_borrow_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@repay_borrow_event_signature, handler_configs}
  end

  defp repay_borrow_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "payer",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "borrower",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "repayAmount",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "accountBorrows",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "totalBorrows",
          "type" => "uint256"
        }
      ],
      "name" => "RepayBorrow",
      "type" => "event"
    }
  end

  @liquidate_borrow_event_signature "LiquidateBorrow(address,address,uint256,address,uint256)"
  @liquidate_borrow_struct Rube.Compound.Events.LiquidateBorrow
  defp liquidate_borrow(enabled: enabled) do
    abi = [
      liquidate_borrow_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @liquidate_borrow_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@liquidate_borrow_event_signature, handler_configs}
  end

  defp liquidate_borrow_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "liquidator",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "borrower",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "repayAmount",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "cTokenCollateral",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "seizeTokens",
          "type" => "uint256"
        }
      ],
      "name" => "LiquidateBorrow",
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
