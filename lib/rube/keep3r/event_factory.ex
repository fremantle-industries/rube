defmodule Rube.Keep3r.EventFactory do
  @type event_signature :: String.t()
  @type log_subscription_config :: %{
    enabled: boolean,
    struct: module,
    handler: mfa,
    abi: [map]
  }
  @type log_subscription_config_tuple :: {event_signature, [log_subscription_config]}
  @type opt :: 
    {:submit_job_enabled, boolean}
    | {:remove_job_enabled, boolean}
    | {:unbond_job_enabled, boolean}
    | {:job_added_enabled, boolean}
    | {:job_removed_enabled, boolean}
    | {:add_credit_enabled, boolean}
    | {:apply_credit_enabled, boolean}
    | {:keeper_worked_enabled, boolean}
    | {:keeper_bonding_enabled, boolean}
    | {:keeper_bonded_enabled, boolean}
    | {:keeper_unbonding_enabled, boolean}
    | {:keeper_unbound_enabled, boolean}
    | {:keeper_slashed_enabled, boolean}
    | {:keeper_dispute_enabled, boolean}
    | {:keeper_resolved_enabled, boolean}

  @spec create([opt]) :: [log_subscription_config_tuple]
  def create(opts) do
    [
      submit_job(enabled: get_opt(opts, :submit_job_enabled, true)),
      remove_job(enabled: get_opt(opts, :remove_job_enabled, true)),
      unbond_job(enabled: get_opt(opts, :unbond_job_enabled, true)),
      job_added(enabled: get_opt(opts, :job_added_enabled, true)),
      job_removed(enabled: get_opt(opts, :job_removed_enabled, true)),
      add_credit(enabled: get_opt(opts, :add_credit_enabled, true)),
      apply_credit(enabled: get_opt(opts, :apply_credit_enabled, true)),
      keeper_worked(enabled: get_opt(opts, :keeper_worked_enabled, true)),
      keeper_bonding(enabled: get_opt(opts, :keeper_bonding_enabled, true)),
      keeper_bonded(enabled: get_opt(opts, :keeper_bonded_enabled, true)),
      keeper_unbonding(enabled: get_opt(opts, :keeper_unbonding_enabled, true)),
      keeper_unbound(enabled: get_opt(opts, :keeper_unbound_enabled, true)),
      keeper_slashed(enabled: get_opt(opts, :keeper_slashed_enabled, true)),
      keeper_dispute(enabled: get_opt(opts, :keeper_dispute_enabled, true)),
      keeper_resolved(enabled: get_opt(opts, :keeper_resolved_enabled, true))
    ]
  end

  @submit_job_event_signature "SubmitJob(address,address,address,uint256,uint256)"
  @submit_job_struct Rube.Keep3r.Events.SubmitJob
  defp submit_job(enabled: enabled) do
    abi = [
      submit_job_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @submit_job_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@submit_job_event_signature, handler_configs}
  end

  defp submit_job_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "liquidity",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "provider",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "credit",
          "type" => "uint256"
        }
      ],
      "name" => "SubmitJob",
      "type" => "event"
    }
  end

  @remove_job_event_signature "RemoveJob(address,address,address,uint256,uint256)"
  @remove_job_struct Rube.Keep3r.Events.RemoveJob
  defp remove_job(enabled: enabled) do
    abi = [
      remove_job_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @remove_job_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@remove_job_event_signature, handler_configs}
  end

  defp remove_job_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "liquidity",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "provider",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "credit",
          "type" => "uint256"
        }
      ],
      "name" => "RemoveJob",
      "type" => "event"
    }
  end

  @unbond_job_event_signature "UnbondJob(address,address,address,uint256,uint256)"
  @unbond_job_struct Rube.Keep3r.Events.UnbondJob
  defp unbond_job(enabled: enabled) do
    abi = [
      unbond_job_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @unbond_job_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@unbond_job_event_signature, handler_configs}
  end

  defp unbond_job_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "liquidity",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "provider",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "credit",
          "type" => "uint256"
        }
      ],
      "name" => "UnbondJob",
      "type" => "event"
    }
  end

  @job_added_event_signature "JobAdded(address,uint256,address)"
  @job_added_struct Rube.Keep3r.Events.JobAdded
  defp job_added(enabled: enabled) do
    abi = [
      job_added_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @job_added_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@job_added_event_signature, handler_configs}
  end

  defp job_added_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "governance",
          "type" => "address"
        }
      ],
      "name" => "JobAdded",
      "type" => "event"
    }
  end

  @job_removed_event_signature "JobRemoved(address,uint256,address)"
  @job_removed_struct Rube.Keep3r.Events.JobRemoved
  defp job_removed(enabled: enabled) do
    abi = [
      job_removed_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @job_removed_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@job_removed_event_signature, handler_configs}
  end

  defp job_removed_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "address",
          "name" => "governance",
          "type" => "address"
        }
      ],
      "name" => "JobRemoved",
      "type" => "event"
    }
  end

  @add_credit_event_signature "AddCredit(address,address,address,uint256,uint256)"
  @add_credit_struct Rube.Keep3r.Events.AddCredit
  defp add_credit(enabled: enabled) do
    abi = [
      add_credit_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @add_credit_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@add_credit_event_signature, handler_configs}
  end

  defp add_credit_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "credit",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "creditor",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "amount",
          "type" => "uint256"
        }
      ],
      "name" => "AddCredit",
      "type" => "event"
    }
  end

  @apply_credit_event_signature "ApplyCredit(address,address,address,uint256,uint256)"
  @apply_credit_struct Rube.Keep3r.Events.ApplyCredit
  defp apply_credit(enabled: enabled) do
    abi = [
      apply_credit_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @apply_credit_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@apply_credit_event_signature, handler_configs}
  end

  defp apply_credit_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "liquidity",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "provider",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "credit",
          "type" => "uint256"
        }
      ],
      "name" => "ApplyCredit",
      "type" => "event"
    }
  end

  @keeper_worked_event_signature "KeeperWorked(address,address,address,uint256,uint256)"
  @keeper_worked_struct Rube.Keep3r.Events.KeeperWorked
  defp keeper_worked(enabled: enabled) do
    abi = [
      keeper_worked_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_worked_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_worked_event_signature, handler_configs}
  end

  defp keeper_worked_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "credit",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "job",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "amount",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperWorked",
      "type" => "event"
    }
  end

  @keeper_bonding_event_signature "KeeperBonding(address,uint256,uint256,uint256)"
  @keeper_bonding_struct Rube.Keep3r.Events.KeeperBonding
  defp keeper_bonding(enabled: enabled) do
    abi = [
      keeper_bonding_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_bonding_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_bonding_event_signature, handler_configs}
  end

  defp keeper_bonding_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "active",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "bond",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperBonding",
      "type" => "event"
    }
  end

  @keeper_bonded_event_signature "KeeperBonded(address,uint256,uint256,uint256)"
  @keeper_bonded_struct Rube.Keep3r.Events.KeeperBonded
  defp keeper_bonded(enabled: enabled) do
    abi = [
      keeper_bonded_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_bonded_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_bonded_event_signature, handler_configs}
  end

  defp keeper_bonded_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "activated",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "bond",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperBonded",
      "type" => "event"
    }
  end

  @keeper_unbonding_event_signature "KeeperUnbonding(address,uint256,uint256,uint256)"
  @keeper_unbonding_struct Rube.Keep3r.Events.KeeperUnbonding
  defp keeper_unbonding(enabled: enabled) do
    abi = [
      keeper_unbonding_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_unbonding_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_unbonding_event_signature, handler_configs}
  end

  defp keeper_unbonding_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "deactive",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "bond",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperUnbonding",
      "type" => "event"
    }
  end

  @keeper_unbound_event_signature "KeeperUnbound(address,uint256,uint256,uint256)"
  @keeper_unbound_struct Rube.Keep3r.Events.KeeperUnbound
  defp keeper_unbound(enabled: enabled) do
    abi = [
      keeper_unbound_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_unbound_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_unbound_event_signature, handler_configs}
  end

  defp keeper_unbound_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "deactivated",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "bond",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperUnbound",
      "type" => "event"
    }
  end

  @keeper_slashed_event_signature "KeeperSlashed(address,address,uint256,uint256)"
  @keeper_slashed_struct Rube.Keep3r.Events.KeeperSlashed
  defp keeper_slashed(enabled: enabled) do
    abi = [
      keeper_slashed_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_slashed_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_slashed_event_signature, handler_configs}
  end

  defp keeper_slashed_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "slasher",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "slash",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperSlashed",
      "type" => "event"
    }
  end

  @keeper_dispute_event_signature "KeeperDispute(address,uint256)"
  @keeper_dispute_struct Rube.Keep3r.Events.KeeperDispute
  defp keeper_dispute(enabled: enabled) do
    abi = [
      keeper_dispute_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_dispute_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_dispute_event_signature, handler_configs}
  end

  defp keeper_dispute_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperDispute",
      "type" => "event"
    }
  end

  @keeper_resolved_event_signature "KeeperResolved(address,uint256)"
  @keeper_resolved_struct Rube.Keep3r.Events.KeeperResolved
  defp keeper_resolved(enabled: enabled) do
    abi = [
      keeper_resolved_abi(),  # standard contract
    ]
    handler_configs = [
      handler_config(
        enabled: enabled,
        struct: @keeper_resolved_struct,
        abi: abi,
        handler: {Rube.EventHandler, :handle_event, []}
      )
    ]

    {@keeper_resolved_event_signature, handler_configs}
  end

  defp keeper_resolved_abi do
    %{
      "anonymous" => false,
      "inputs" => [
        %{
          "indexed" => true,
          "internalType" => "address",
          "name" => "keeper",
          "type" => "address"
        },
        %{
          "indexed" => false,
          "internalType" => "uint256",
          "name" => "block",
          "type" => "uint256"
        }
      ],
      "name" => "KeeperResolved",
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
