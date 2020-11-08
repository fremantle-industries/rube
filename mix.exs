defmodule Rube.MixProject do
  use Mix.Project

  def project do
    [
      app: :rube,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
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
      {:phoenix, "~> 1.5.5"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.14.6"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_dashboard, "~> 0.2"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: &test/1,
      "test.base": ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "test.docker": &test_docker/1
    ]
  end

  defp test(args) do
    System.get_env("DOCKER")
    |> case do
      "true" -> "test.docker"
      _ -> "test.base"
    end
    |> Mix.Task.run(args)
  end

  defp test_docker(args) do
    System.cmd(
      "docker-compose",
      Enum.concat(["run", "-e", "MIX_ENV=test", "web", "mix", "test", "--color"], args),
      into: IO.stream(:stdio, :line)
    )
  end
end
