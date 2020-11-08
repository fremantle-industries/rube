use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
partition = System.get_env("MIX_TEST_PARTITION")
default_database_url = "postgres://postgres:postgres@db:5432/rube_?"
configured_database_url = System.get_env("DATABASE_URL") || default_database_url
database_url = "#{String.replace(configured_database_url, "?", "test")}#{partition}"

config :rube, Rube.Repo,
  url: database_url,
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rube, RubeWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
