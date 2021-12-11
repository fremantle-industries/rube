defmodule RubeWeb.Router do
  use RubeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RubeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RubeWeb do
    pipe_through :browser

    live_session :default do
      live "/", HomeLive, :index
      live "/tokens", Token.IndexLive, :index, as: :token
      live "/tokens/:blockchain_id/:address", Token.ShowLive, :show, as: :token
      live "/money_markets", MoneyMarketLive, :index
      live "/amm", AmmLive, :index
      live "/future_swap", FutureSwapLive, :index
      live "/perpetual_protocol", PerpetualProtocolLive, :index
      live "/injective_protocol", InjectiveProtocolLive, :index
      live "/vega_protocol", VegaProtocolLive, :index
      live "/chainlink", ChainlinkLive, :index
      live "/keep3r", Keep3rLive, :index
    end
  end

  scope "/", NotifiedPhoenix do
    pipe_through :browser

    live_session :notifications, root_layout: {RubeWeb.LayoutView, :root} do
      live("/notifications", ListLive, :index, as: :notification)
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RubeWeb.Telemetry
    end
  end
end
