defmodule Rube.Chainlink.EventFactory do
  @type event_signature :: String.t()
  @type log_subscription_config :: %{
    enabled: boolean,
    struct: module,
    handler: mfa,
    abi: [map]
  }
  @type log_subscription_config_tuple :: {event_signature, [log_subscription_config]}
  @type opt :: {:added_access_enabled, boolean}

  @spec create([opt]) :: [log_subscription_config_tuple]
  def create(opts) do
    [
      added_access(enabled: get_opt(opts, :added_access_enabled, true)),
      answer_updated(enabled: get_opt(opts, :answer_updated_enabled, true)),
      available_funds_updated(enabled: get_opt(opts, :available_funds_updated_enabled, true)),
      new_round(enabled: get_opt(opts, :new_round_enabled, true)),
      round_details_updated(enabled: get_opt(opts, :round_details_updated_enabled, true)),
      submission_received(enabled: get_opt(opts, :submission_received_enabled, true)),
      validator_updated(enabled: get_opt(opts, :validator_updated_enabled, true)),
      new_transmission(enabled: get_opt(opts, :new_transmission_enabled, true))
    ]
  end

  @added_access_event_signature "AddedAccess(address)"
  @added_access_struct Rube.Chainlink.Events.AddedAccess
  defp added_access(enabled: enabled) do
    abi = [
      added_access_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @added_access_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@added_access_event_signature, handler_configs}
  end

  defp added_access_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "user",
          "type" => "address"
        }
      ],
      "name" => "AddedAccess",
      "type" => "event"
    }
  end

  @answer_updated_event_signature "AnswerUpdated(int256,uint256,uint256)"
  @answer_updated_struct Rube.Chainlink.Events.AnswerUpdated
  defp answer_updated(enabled: enabled) do
    abi = [
      answer_updated_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @answer_updated_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@answer_updated_event_signature, handler_configs}
  end

  defp answer_updated_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "int256",
          "name" => "current",
          "type" => "int256"
        },
        %{
          "indexed" => true,
          "internalType" => "uint256",
          "name" => "roundId",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "updatedAt",
          "type" => "uint256"
        }
      ],
      "name" => "AnswerUpdated",
      "type" => "event"
    }
  end

  @available_funds_updated_event_signature "AvailableFundsUpdated(uint256)"
  @available_funds_updated_struct Rube.Chainlink.Events.AvailableFundsUpdated
  defp available_funds_updated(enabled: enabled) do
    abi = [
      available_funds_updated_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @available_funds_updated_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@available_funds_updated_event_signature, handler_configs}
  end

  defp available_funds_updated_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "uint256",
          "name" => "amount",
          "type" => "uint256"
        }
      ],
      "name" => "AvailableFundsUpdated",
      "type" => "event"
    }
  end

  @new_round_event_signature "NewRound(uint256,address,uint256)"
  @new_round_struct Rube.Chainlink.Events.NewRound
  defp new_round(enabled: enabled) do
    abi = [
      new_round_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @new_round_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@new_round_event_signature, handler_configs}
  end

  defp new_round_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "uint256",
          "name" => "roundId",
          "type" => "uint256"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "startedBy",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "startedAt",
          "type" => "uint256"
        }
      ],
      "name" => "NewRound",
      "type" => "event"
    }
  end

  @round_details_updated_event_signature "RoundDetailsUpdated(uint128,uint32,uint32,uint32,uint32)"
  @round_details_updated_struct Rube.Chainlink.Events.RoundDetailsUpdated
  defp round_details_updated(enabled: enabled) do
    abi = [
      round_details_updated_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @round_details_updated_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@round_details_updated_event_signature, handler_configs}
  end

  defp round_details_updated_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "uint128",
          "name" => "paymentAmount",
          "type" => "uint128"
        },
        %{
          "indexed" => true,
          "internalType" => "uint32",
          "name" => "minSubmissionCount",
          "type" => "uint32"
        },
        %{
          "indexed" => true,
          "internalType" => "uint32",
          "name" => "maxSubmissionCount",
          "type" => "uint32"
        },
        %{
          "indexed" => false,
          "internalType" => "uint32",
          "name" => "restartDelay",
          "type" => "uint32"
        },
        %{
          "indexed" => false,
          "internalType" => "uint32",
          "name" => "timeout",
          "type" => "uint32"
        }
        ],
        "name" => "RoundDetailsUpdated",
        "type" => "event"
        }
  end

  @submission_received_event_signature "SubmissionReceived(int256,uint32,address)"
  @submission_received_struct Rube.Chainlink.Events.SubmissionReceived
  defp submission_received(enabled: enabled) do
    abi = [
      submission_received_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @submission_received_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@submission_received_event_signature, handler_configs}
  end

  defp submission_received_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "int256",
          "name" => "submission",
          "type" => "int256"
        },
        %{
          "indexed" => true,
          "internalType" => "uint32",
          "name" => "round",
          "type" => "uint32"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "oracle",
          "type" => "address"
        }
      ],
      "name" => "SubmissionReceived",
      "type" => "event"
    }
  end

  @validator_updated_event_signature "ValidatorUpdated(address,address)"
  @validator_updated_struct Rube.Chainlink.Events.ValidatorUpdated
  defp validator_updated(enabled: enabled) do
    abi = [
      validator_updated_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @validator_updated_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@validator_updated_event_signature, handler_configs}
  end

  defp validator_updated_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "previous",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "current",
          "type" => "address"
        }
      ],
      "name" => "ValidatorUpdated",
      "type" => "event"
    }
  end

  @new_transmission_event_signature "NewTransmission(uint32,int192,address,int192[],bytes,bytes32)"
  @new_transmission_struct Rube.Chainlink.Events.NewTransmission
  defp new_transmission(enabled: enabled) do
    abi = [
      new_transmission_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @new_transmission_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@new_transmission_event_signature, handler_configs}
  end

  defp new_transmission_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "uint32",
          "name" => "aggregatorRoundId",
          "type" => "uint32"
        },
        %{
          "indexed" => false,
          "internalType" => "int192",
          "name" => "answer",
          "type" => "int192"
        },
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "transmitter",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "int192[]",
          "name" => "observations",
          "type" => "int192[]"
        },
        %{
          "indexed" => false,
          "internalType" => "bytes",
          "name" => "observers",
          "type" => "bytes"
        },
        %{
          "indexed" => false,
          "internalType" => "bytes32",
          "name" => "rawReportContext",
          "type" => "bytes32"
        }
        ],
        "name" => "NewTransmission",
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
