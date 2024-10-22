defmodule Rube.MixProject do
  use Mix.Project

  def project do
    [
      app: :rube,
      version: "0.0.4",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package(),
      preferred_cli_env: [
        "test.docker": :test
      ]
    ]
  end

  def application do
    [
      mod: {Rube.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:accessible, "~> 0.3"},
      {:deque, "~> 1.0"},
      {:ecto_sql, "~> 3.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:master_proxy, "~> 0.1"},
      {:navigator, "~> 0.0.6"},
      {:notified_phoenix, "~> 0.0.7"},
      {:phoenix, "~> 1.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_dashboard, "~> 0.5"},
      {:phoenix_live_view, "~> 0.17"},
      {:phoenix_live_react, "~> 0.4.1"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      # {:slurp, github: "fremantle-industries/slurp", branch: "main", override: true},
      {:slurp, "~> 0.0.11"},
      # {:slurpee, github: "fremantle-industries/slurpee", branch: "main", override: true},
      {:slurpee, "~> 0.0.14"},
      # {:stylish, github: "fremantle-industries/stylish", branch: "main", override: true},
      {:stylish, "~> 0.0.8"},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics_prometheus, "~> 1.0"},
      {:logger_file_backend, "~> 0.0.10", only: [:dev, :test]},
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_unit_notifier, "~> 1.0", only: :test},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      "setup.deps": ["deps.get", "cmd npm install --prefix assets"],
      setup: ["setup.deps", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp description do
    "A multi-chain DeFi development toolkit"
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Alex Kwiatkowski"],
      links: %{"GitHub" => "https://github.com/fremantle-industries/rube"}
    }
  end
end
