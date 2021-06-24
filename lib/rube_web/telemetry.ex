defmodule RubeWeb.Telemetry do
  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000},
      {TelemetryMetricsPrometheus,
       [
         metrics: metrics(),
         name: prometheus_metrics_name(),
         port: prometheus_metrics_port(),
         options: [ref: :"TelemetryMetricsPrometheus.Router.HTTP_#{prometheus_metrics_port()}"]
       ]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def metrics do
    [
      # Phoenix Metrics
      last_value("phoenix.endpoint.stop.duration",
        unit: {:native, :millisecond}
      ),
      last_value("phoenix.router_dispatch.stop.duration",
        tags: [:route],
        unit: {:native, :millisecond}
      ),

      # Database Metrics
      last_value("rube.repo.query.total_time", unit: {:native, :millisecond}),
      last_value("rube.repo.query.decode_time", unit: {:native, :millisecond}),
      last_value("rube.repo.query.query_time", unit: {:native, :millisecond}),
      last_value("rube.repo.query.queue_time", unit: {:native, :millisecond}),
      last_value("rube.repo.query.idle_time", unit: {:native, :millisecond}),

      # Rube Metrics
      last_value("rube.amm.pair_price.price",
        tags: [
          :blockchain_id,
          :address,
          :token0_address,
          :token1_address,
          :token0_symbol,
          :token1_symbol
        ]
      ),
      last_value("rube.amm.pair_reserve0.reserve",
        tags: [:blockchain_id, :address, :token_address, :token_symbol]
      ),
      last_value("rube.amm.pair_reserve1.reserve",
        tags: [:blockchain_id, :address, :token_address, :token_symbol]
      )
    ]
  end

  defp prometheus_metrics_name do
    Application.get_env(:rube, :metrics_name, :rube_prometheus_metrics)
  end

  defp prometheus_metrics_port do
    Application.get_env(:rube, :metrics_port, 9569)
  end

  defp periodic_measurements do
    []
  end
end
