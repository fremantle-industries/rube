import Config

# Shared variables
env = config_env() |> Atom.to_string()
http_port = (System.get_env("HTTP_PORT") || "4000") |> String.to_integer()
rube_host = System.get_env("RUBE_HOST") || "rube.localhost"
slurpee_host = System.get_env("SLURPEE_HOST") || "slurpee.localhost"
grafana_host = System.get_env("GRAFANA_HOST") || "grafana.localhost"
prometheus_host = System.get_env("PROMETHEUS_HOST") || "prometheus.localhost"

rube_secret_key_base =
  System.get_env("RUBE_SECRET_KEY_BASE") ||
    "VhjIWW8RIYio3ahvuu8TTZxDnbNQQXM3z5XaDTXZbrX6yp6qpFrAm6Pg8MutmLbi"

rube_live_view_signing_salt =
  System.get_env("RUBE_LIVE_VIEW_SIGNING_SALT") || "vSli21+/uc7Fd0hPfceOqcMa0JhgV8JM"

slurpee_secret_key_base =
  System.get_env("SLURPEE_SECRET_KEY_BASE") ||
    "WMCArOAMsL3FY6qXzWOzyk4BqIScWLRfE4qJVqaQSpDkra3F+PR6SSbyUEAj6dwV"

slurpee_live_view_signing_salt =
  System.get_env("SLURPEE_LIVE_VIEW_SIGNING_SALT") || "mdFV42VylhGOMhw7vUylMXRBW819/Sj1"

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
  secret_key_base: rube_secret_key_base,
  render_errors: [view: RubeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Slurpee.PubSub,
  live_view: [signing_salt: rube_live_view_signing_salt]

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
        label: "Perpetual",
        link: {RubeWeb.Router.Helpers, :perpetual_protocol_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "Injective",
        link: {RubeWeb.Router.Helpers, :injective_protocol_path, [RubeWeb.Endpoint, :index]}
      },
      %{
        label: "Vega",
        link: {RubeWeb.Router.Helpers, :vega_protocol_path, [RubeWeb.Endpoint, :index]}
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
      },
      %{
        label: "Grafana",
        link: "http://#{grafana_host}"
      },
      %{
        label: "Prometheus",
        link: "http://#{prometheus_host}"
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
      },
      %{
        label: "Grafana",
        link: "http://#{grafana_host}"
      },
      %{
        label: "Prometheus",
        link: "http://#{prometheus_host}"
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

# logger
config :logger, backends: [{LoggerFileBackend, :file_log}]
config :logger, :file_log, path: "./log/#{config_env()}.log", metadata: [:blockchain_id]

if System.get_env("DEBUG") == "true" do
  config :logger, :file_log, level: :debug
else
  config :logger, :file_log, level: :info
end

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
        start_on_boot: false,
        name: "Ethereum",
        adapter: Slurp.Adapters.Evm,
        network_id: 1,
        chain_id: 1,
        chain: "ETH",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        explorer: {Slurp.ExplorerAdapters.Etherscan, "https://etherscan.io"},
        rpc: [
          # "https://mainnet.infura.io/v3/${INFURA_API_KEY}",
          # "wss://mainnet.infura.io/ws/v3/${INFURA_API_KEY}",
          "https://api.mycryptoapi.com/eth"
          # "https://cloudflare-eth.com"
        ]
      },
      "bsc-mainnet" => %{
        start_on_boot: false,
        name: "Binance Smart Chain",
        adapter: Slurp.Adapters.Evm,
        network_id: 56,
        chain_id: 56,
        chain: "BSC",
        testnet: false,
        new_head_initial_history: 0,
        poll_interval_ms: 1_000,
        explorer: {Slurp.ExplorerAdapters.BscScan, "https://bscscan.com"},
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
        explorer: {Slurp.ExplorerAdapters.Polygonscan, "https://polygonscan.com"},
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
        explorer: {Slurp.ExplorerAdapters.Blockscout, "https://blockscout.com/xdai/mainnet/"},
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
        start_on_boot: true,
        name: "Avalanche",
        adapter: Slurp.Adapters.Evm,
        network_id: 43114,
        chain_id: 43114,
        chain: "Avax",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        explorer: {Slurp.ExplorerAdapters.Avascan, "https://avascan.info/blockchain/c"},
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
        explorer: {Slurp.ExplorerAdapters.Etherscan, "https://optimistic.etherscan.io"},
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
        explorer: {Slurp.ExplorerAdapters.Ftmscan, "https://ftmscan.com"},
        rpc: [
          "https://rpcapi.fantom.network"
          # "wss://ws-mainnet.matic.network"
        ]
      }
    }

  config :slurp,
    log_subscriptions: %{
      "*" => [
        # {Rube.Erc20.EventFactory, :create, [[approval_enabled: true, transfer_enabled: true]]},
        # {
        #   Rube.Chainlink.EventFactory,
        #   :create,
        #   [
        #     [
        #       added_access_enabled: true,
        #       answer_updated_enabled: true,
        #       available_funds_updated_enabled: true,
        #       new_round_enabled: true,
        #       round_details_updated_enabled: true,
        #       submission_received_enabled: true,
        #       validator_updated_enabled: true,
        #       new_transmission_enabled: true
        #     ]
        #   ]
        # },
        # {
        #   Rube.Compound.EventFactory,
        #   :create,
        #   [
        #     [
        #       accrue_interest_enabled: false,
        #       redeem_enabled: false,
        #       borrow_enabled: false,
        #       repay_borrow_enabled: false,
        #       liquidate_borrow_enabled: false
        #     ]
        #   ]
        # },
        {
          Rube.Compound.EventFactory,
          :create,
          [
            [
              accrue_interest_enabled: true,
              redeem_enabled: true,
              borrow_enabled: true,
              repay_borrow_enabled: true,
              liquidate_borrow_enabled: true
            ]
          ]
        },
        # {Rube.Kashi.EventFactory, :create, [[log_accrue_enabled: false]]},
        # {Rube.Kashi.EventFactory, :create, [[log_accrue_enabled: true]]}
        {
          Rube.Keep3r.EventFactory,
          :create,
          [
            [
              submit_job_enabled: false,
              remove_job_enabled: false,
              unbond_job_enabled: false,
              job_added_enabled: false,
              job_removed_enabled: false,
              add_credit_enabled: false,
              apply_credit_enabled: false,
              keeper_worked_enabled: false,
              keeper_bonding_enabled: false,
              keeper_bonded_enabled: false,
              keeper_unbonding_enabled: false,
              keeper_unbound_enabled: false,
              keeper_slashed_enabled: false,
              keeper_dispute_enabled: false,
              keeper_resolved_enabled: false
            ]
          ]
        },
        {Rube.Uniswap.EventFactory, :create, [[swap_enabled: false, sync_enabled: false]]},
        {Rube.FutureSwap.EventFactory, :create, [[trade_open_enabled: false, trade_liquidate_enabled: false]]}
      ]
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
