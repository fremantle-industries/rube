import Config

# ecto_repos need to be set at compile time
config :rube, ecto_repos: [Rube.Repo]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :blockchain_id]
