import Config

# Shared variables
env = config_env() |> Atom.to_string()
http_port = (System.get_env("HTTP_PORT") || "4000") |> String.to_integer()
rube_host = System.get_env("RUBE_HOST") || "rube.localhost"
slurpee_host = System.get_env("SLURPEE_HOST") || "slurpee.localhost"

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    "aklUQV064QnGvw4oQ9e+Sp5fmTlkig09P/bxk3AfCSsYHQPDVeHfL9h08XUnr9xY"

live_view_signing_salt = System.get_env("LIVE_VIEW_SIGNING_SALT") || "ecn/jrqJ"

slurpee_secret_key_base =
  System.get_env("SLURPEE_SECRET_KEY_BASE") ||
    "NkP87zQb0idxzEodaHlKhmVVPbXhIiMie7U521qywHux2p+c+j2UtOxEdlCe69+5"

slurpee_live_view_signing_salt =
  System.get_env("SLURPEE_LIVE_VIEW_SIGNING_SALT") || "HlwOm8xFfFVMhHks8GhXdG6TavCBzcbw"

# Configure your database
partition = System.get_env("MIX_TEST_PARTITION")
default_database_url = "postgres://postgres:postgres@localhost:5432/rube_?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url
database_url = "#{String.replace(configured_database_url, "?", env)}#{partition}"

# Rube
config :rube, Rube.Repo,
  url: database_url,
  pool_size: 10

config :rube, RubeWeb.Endpoint,
  url: [host: rube_host, port: http_port],
  secret_key_base: secret_key_base,
  render_errors: [view: RubeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Slurpee.PubSub,
  live_view: [signing_salt: live_view_signing_salt]

# Slurpee
config :slurpee, SlurpeeWeb.Endpoint,
  url: [host: slurpee_host, port: http_port],
  pubsub_server: Slurpee.PubSub,
  secret_key_base: slurpee_secret_key_base,
  live_view: [signing_salt: slurpee_live_view_signing_salt],
  server: false

# Master Proxy
config :master_proxy,
  # any Cowboy options are allowed
  http: [:inet6, port: http_port],
  # https: [:inet6, port: 4443],
  backends: [
    %{
      host: ~r/#{rube_host}/,
      phoenix_endpoint: RubeWeb.Endpoint
    },
    %{
      host: ~r/#{slurpee_host}/,
      phoenix_endpoint: SlurpeeWeb.Endpoint
    }
  ]

# Navigation
config :navigator,
  links: %{
    rube: [
      %{
        label: "Rube",
        link: {RubeWeb.Router.Helpers, :home_path, [RubeWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Tokens",
        link: {RubeWeb.Router.Helpers, :token_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "Money Markets",
        link: {RubeWeb.Router.Helpers, :money_market_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "AMM",
        link: {RubeWeb.Router.Helpers, :amm_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "FutureSwap",
        link: {RubeWeb.Router.Helpers, :future_swap_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "Chainlink",
        link: {RubeWeb.Router.Helpers, :chainlink_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "Keep3r",
        link: {RubeWeb.Router.Helpers, :keep3r_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "Slurpee",
        link: {SlurpeeWeb.Router.Helpers, :home_url, [SlurpeeWeb.Endpoint, :index]}
      }
    ],
    slurpee: [
      %{
        label: "Slurpee",
        link: {SlurpeeWeb.Router.Helpers, :home_path, [SlurpeeWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Blockchains",
        link: {SlurpeeWeb.Router.Helpers, :blockchain_path, [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "Log Subscriptions",
        link: {SlurpeeWeb.Router.Helpers, :log_subscription_path, [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "New Head Subscriptions",
        link:
          {SlurpeeWeb.Router.Helpers, :new_head_subscription_path, [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "Transaction Subscriptions",
        link:
          {SlurpeeWeb.Router.Helpers, :transaction_subscription_path,
           [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "Rube",
        link: {RubeWeb.Router.Helpers, :home_url, [RubeWeb.Endpoint, :index]}
      }
    ]
  }

# Notifications
config :notified, pubsub_server: Slurpee.PubSub
config :notified, receivers: []

config :notified_phoenix,
  to_list: {RubeWeb.Router.Helpers, :notification_path, [RubeWeb.Endpoint, :index]}

# Blockchain Connections
# TODO: The long term aim is to not need this at all. It should be dynamically configured
config :ethereumex, client_type: :http

# Slurp
config :slurp, blockchains: %{}
# config :slurp, new_heads_subscription_enabled: true
config :slurp,
  new_head_subscriptions: %{
    "*" => [
      %{
        enabled: true,
        handler: {Slurpee.NewHeadHandler, :handle_new_head, []}
      }
    ]
  }

# config :slurp, log_subscriptions_enabled: true
config :slurp, log_subscriptions: %{}
# config :slurp, transaction_subscription_enabled: true
# config :slurp, transaction_subscription_handler: {Examples.Transactions, :handle_transaction, []}

# Conditional configuration
# Dev
if config_env() == :dev do
  config :rube, Rube.Repo, show_sensitive_data_on_connection_error: true

  # For development, we disable any cache and enable
  # debugging and code reloading.
  #
  # The watchers configuration can be used to run external
  # watchers to your application. For example, we use it
  # with webpack to recompile .js and .css sources.
  config :rube, RubeWeb.Endpoint,
    server: true,
    debug_errors: true,
    code_reloader: true,
    check_origin: false,
    watchers: [
      npm: [
        "run",
        "watch",
        cd: Path.expand("../assets", __DIR__)
      ]
    ]

  # ## SSL Support
  #
  # In order to use HTTPS in development, a self-signed
  # certificate can be generated by running the following
  # Mix task:
  #
  #     mix phx.gen.cert
  #
  # Note that this task requires Erlang/OTP 20 or later.
  # Run `mix help phx.gen.cert` for more information.
  #
  # The `http:` config above can be replaced with:
  #
  #     https: [
  #       port: 4001,
  #       cipher_suite: :strong,
  #       keyfile: "priv/cert/selfsigned_key.pem",
  #       certfile: "priv/cert/selfsigned.pem"
  #     ],
  #
  # If desired, both `http:` and `https:` keys can be
  # configured to run both http and https servers on
  # different ports.

  # Watch static and templates for browser reloading.
  config :rube, RubeWeb.Endpoint,
    live_reload: [
      patterns: [
        ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
        ~r"priv/gettext/.*(po)$",
        ~r"lib/rube_web/(live|views)/.*(ex)$",
        ~r"lib/rube_web/templates/.*(eex)$"
      ]
    ]

  # Set a higher stacktrace during development. Avoid configuring such
  # in production as building large stacktraces may be expensive.
  config :phoenix, :stacktrace_depth, 20

  # Initialize plugs at runtime for faster development compilation
  config :phoenix, :plug_init_mode, :runtime

  # config :keeper, provider: Keeper.Vault
  # config :keeper, provider: Keeper.AWS
  # config :keeper, provider: Keeper.GCP
  # config :keeper, provider: Keeper.Memory
  # config :keeper, provider: Keeper.File

  # config :slurp, websocket_rpc_enabled: false
  # config :slurp, subscription_enabled: false

  config :slurp,
    blockchains: %{
      "eth-mainnet" => %{
        start_on_boot: true,
        name: "Ethereum",
        adapter: Slurp.Adapters.Evm,
        network_id: 1,
        chain_id: 1,
        chain: "ETH",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        rpc: [
          # "https://mainnet.infura.io/v3/${INFURA_API_KEY}",
          # "wss://mainnet.infura.io/ws/v3/${INFURA_API_KEY}",
          "https://api.mycryptoapi.com/eth"
          # "https://cloudflare-eth.com"
        ]
      },
      "bsc-mainnet" => %{
        start_on_boot: true,
        name: "Binance Smart Chain",
        adapter: Slurp.Adapters.Evm,
        network_id: 56,
        chain_id: 56,
        chain: "BSC",
        testnet: false,
        new_head_initial_history: 0,
        poll_interval_ms: 1_000,
        rpc: [
          "https://bsc-dataseed1.binance.org"
          # "https://bsc-dataseed2.binance.org",
          # "https://bsc-dataseed3.binance.org",
          # "https://bsc-dataseed4.binance.org",
          # "https://bsc-dataseed1.defibit.io",
          # "https://bsc-dataseed2.defibit.io",
          # "https://bsc-dataseed3.defibit.io",
          # "https://bsc-dataseed4.defibit.io",
          # "https://bsc-dataseed1.ninicoin.io",
          # "https://bsc-dataseed2.ninicoin.io",
          # "https://bsc-dataseed3.ninicoin.io",
          # "https://bsc-dataseed4.ninicoin.io",
          # "wss://bsc-ws-node.nariox.org"
        ]
      },
      # TODO: Requires a separate adapter. Doesn't have the same RPC methods
      # "okex-mainnet" => %{
      #   start_on_boot: false,
      #   name: "OkEx Chain Mainnet",
      #   adapter: Slurp.Adapters.OkEx,
      #   network_id: 66,
      #   chain_id: 66,
      #   chain: "okexchain",
      #   testnet: false,
      #   new_head_initial_history: 0,
      #   poll_interval_ms: 1_000,
      #   rpc: [
      #     "https://www.okex.com/okexchain-rpc"
      #   ]
      # },
      # "ethereum-ropsten" => %{
      #   start_on_boot: false,
      #   name: "Ethereum Testnet Ropsten",
      #   network_id: 3,
      #   chain_id: 3,
      #   chain: "ETH",
      #   testnet: true,
      #   poll_interval_ms: 15_000,
      #   rpc: [
      #     "https://ropsten.infura.io/v3/${INFURA_API_KEY}",
      #     "wss://ropsten.infura.io/ws/v3/${INFURA_API_KEY}"
      #   ]
      # }
      "matic-mainnet" => %{
        start_on_boot: false,
        name: "Matic",
        adapter: Slurp.Adapters.Evm,
        network_id: 137,
        chain_id: 137,
        chain: "Matic",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        rpc: [
          "https://rpc-mainnet.matic.network"
          # "wss://ws-mainnet.matic.network"
        ]
      },
      "xdai-mainnet" => %{
        start_on_boot: false,
        name: "xDAI",
        adapter: Slurp.Adapters.Evm,
        network_id: 100,
        chain_id: 100,
        chain: "xDAI",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        rpc: [
          "https://rpc.xdaichain.com"
          # "https://xdai.poanetwork.dev",
          # "wss://rpc.xdaichain.com/wss",
          # "wss://xdai.poanetwork.dev/wss",
          # "http://xdai.poanetwork.dev",
          # "https://dai.poa.network",
          # "ws://xdai.poanetwork.dev:8546"
        ]
      },
      # TODO: Requires a separate adapter. Doesn't have the same RPC methods
      # "near-mainnet" => %{
      #   start_on_boot: false,
      #   name: "NEAR Mainnet",
      #   adapter: Slurp.Adapters.Near,
      #   network_id: 1_313_161_554,
      #   chain_id: 1_313_161_554,
      #   chain: "NEAR",
      #   testnet: false,
      #   timeout: 5000,
      #   new_head_initial_history: 0,
      #   poll_interval_ms: 2_500,
      #   rpc: [
      #     "https://rpc.mainnet.near.org"
      #   ]
      # },
      "avalanche-mainnet" => %{
        start_on_boot: false,
        name: "Avalanche",
        adapter: Slurp.Adapters.Evm,
        network_id: 43114,
        chain_id: 43114,
        chain: "Avax",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        rpc: [
          "https://api.avax.network/ext/bc/C/rpc"
        ]
      },
      "optimism-mainnet" => %{
        start_on_boot: false,
        name: "Optimistic Ethereum",
        adapter: Slurp.Adapters.Evm,
        network_id: 10,
        chain_id: 10,
        chain: "ETH",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        rpc: [
          "https://mainnet.optimism.io/"
        ]
      },
      # TODO: Requires a separate adapter. Doesn't have the same RPC methods
      # "rsk-mainnet" => %{
      #   start_on_boot: false,
      #   name: "RSK Mainnet",
      #   adapter: Slurp.Adapters.Rsk,
      #   network_id: 30,
      #   chain_id: 30,
      #   chain: "RSK",
      #   testnet: false,
      #   timeout: 5000,
      #   new_head_initial_history: 0,
      #   poll_interval_ms: 2_500,
      #   rpc: [
      #     "https://public-node.rsk.co"
      #     # "https://mycrypto.rsk.co"
      #   ]
      # }
      "fantom-mainnet" => %{
        start_on_boot: false,
        name: "Fantom",
        adapter: Slurp.Adapters.Evm,
        network_id: 250,
        chain_id: 250,
        chain: "FTM",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        rpc: [
          "https://rpcapi.fantom.network"
          # "wss://ws-mainnet.matic.network"
        ]
      }
    }

  config :slurp,
    log_subscriptions: %{
      "*" => %{
        # ERC20
        "Approval(address,address,uint256)" => [
          %{
            enabled: false,
            struct: Rube.Erc20.Events.Approval,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
                    "indexed" => false,
                    "name" => "value",
                    "type" => "uint256"
                  }
                ],
                "name" => "Approval",
                "type" => "event"
              }
            ]
          }
        ],
        "Transfer(address,address,uint256)" => [
          %{
            enabled: false,
            struct: Rube.Erc20.Events.Transfer,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
                    "indexed" => false,
                    "name" => "value",
                    "type" => "uint256"
                  }
                ],
                "name" => "Transfer",
                "type" => "event"
              }
            ]
          }
        ],
        "Mint(address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Erc20.Events.Mint,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
                    "name" => "amount0",
                    "type" => "uint"
                  },
                  %{
                    "indexed" => false,
                    "name" => "amount1",
                    "type" => "uint"
                  }
                ],
                "name" => "Mint",
                "type" => "event"
              }
            ]
          }
        ],
        "Burn(address,uint256,uint256,address)" => [
          %{
            enabled: false,
            struct: Rube.Erc20.Events.Burn,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
                    "name" => "amount0",
                    "type" => "uint"
                  },
                  %{
                    "indexed" => false,
                    "name" => "amount1",
                    "type" => "uint"
                  },
                  %{
                    "indexed" => true,
                    "name" => "to",
                    "type" => "address"
                  }
                ],
                "name" => "Burn",
                "type" => "event"
              }
            ]
          }
        ],
        # AMM - Uniswap, Sushiswap, Pancakeswap etc...
        "Swap(address,uint256,uint256,uint256,uint256,address)" => [
          %{
            enabled: true,
            struct: Rube.Amm.Events.Swap,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "Sync(uint112,uint112)" => [
          %{
            enabled: true,
            struct: Rube.Amm.Events.Sync,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        # Chainlink
        "AddedAccess(address)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.AddedAccess,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "AnswerUpdated(int256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.AnswerUpdated,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "AvailableFundsUpdated(uint256)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.AvailableFundsUpdated,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "NewRound(uint256,address,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.NewRound,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "RoundDetailsUpdated(uint128,uint32,uint32,uint32,uint32)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.NewRound,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "SubmissionReceived(int256,uint32,address)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.SubmissionReceived,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "ValidatorUpdated(address,address)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.ValidatorUpdated,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "NewTransmission(address,address)" => [
          %{
            enabled: true,
            struct: Rube.Chainlink.Events.NewTransmission,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        # Keep3r
        "SubmitJob(address,address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.SubmitJob,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "RemoveJob(address,address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.RemoveJob,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "UnbondJob(address,address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.UnbondJob,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "JobAdded(address,uint256,address)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.JobAdded,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "JobRemoved(address,uint256,address)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.JobRemoved,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "AddCredit(address,address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.AddCredit,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "ApplyCredit(address,address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.ApplyCredit,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperWorked(address,address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperWorked,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperBonding(address,uint256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperBonding,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperBonded(address,uint256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperBonded,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperUnbonding(address,uint256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperUnbonding,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperUnbound(address,uint256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperUnbound,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperSlashed(address,address,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperSlashed,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperDispute(address,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperDispute,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        "KeeperResolved(address,uint256)" => [
          %{
            enabled: true,
            struct: Rube.Keep3r.Events.KeeperResolved,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],
        # Compound
        "AccrueInterest(uint256,uint256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.MoneyMarkets.Events.AccrueInterest,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ],

        # /**
        # * @notice Event emitted when tokens are minted
        # */
        # event Mint(address minter, uint mintAmount, uint mintTokens);

        # /**
        # * @notice Event emitted when tokens are redeemed
        # */
        # event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);

        # /**
        # * @notice Event emitted when underlying is borrowed
        # */
        # event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);

        # /**
        # * @notice Event emitted when a borrow is repaid
        # */
        # event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);

        # /**
        # * @notice Event emitted when a borrow is liquidated
        # */
        # event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);

        # /*** Admin Events ***/

        # /**
        # * @notice Event emitted when pendingAdmin is changed
        # */
        # event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);

        # /**
        # * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
        # */
        # event NewAdmin(address oldAdmin, address newAdmin);

        # /**
        # * @notice Event emitted when comptroller is changed
        # */
        # event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);

        # /**
        # * @notice Event emitted when interestRateModel is changed
        # */
        # event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);

        # /**
        # * @notice Event emitted when the reserve factor is changed
        # */
        # event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);

        # /**
        # * @notice Event emitted when the reserves are added
        # */
        # event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);

        # /**
        # * @notice Event emitted when the reserves are reduced
        # */
        # event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);

        # /**
        # * @notice EIP20 Transfer event
        # */
        # event Transfer(address indexed from, address indexed to, uint amount);

        # /**
        # * @notice EIP20 Approval event
        # */
        # event Approval(address indexed owner, address indexed spender, uint amount);

        # /**
        # * @notice Failure event
        # */
        # event Failure(uint error, uint info, uint detail);

        # FutureSwap
        "TradeOpen(uint256,address,bool,uint256,uint256,uint256,uint256,uint256,uint256,uint256,address)" =>
          [
            %{
              enabled: true,
              struct: Rube.FutureSwap.Events.TradeOpen,
              handler: {Rube.EventHandler, :handle_event, []},
              abi: [
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
              ]
            }
          ],
        "TradeLiquidate(uint256,address,address,uint256,uint256,uint256)" => [
          %{
            enabled: true,
            struct: Rube.FutureSwap.Events.TradeLiquidate,
            handler: {Rube.EventHandler, :handle_event, []},
            abi: [
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
            ]
          }
        ]
      }
    }
end

# Test
if config_env() == :test do
  config :rube, Rube.Repo,
    show_sensitive_data_on_connection_error: true,
    pool: Ecto.Adapters.SQL.Sandbox

  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  config :rube, RubeWeb.Endpoint,
    http: [port: 4002],
    server: false

  # Print only warnings and errors during test
  config :logger, level: :warn
end
