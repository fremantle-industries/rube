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

    live "/", HomeLive, :index
    live "/blockchains", BlockchainLive, :index
    live "/log_subscriptions", LogSubscriptionLive, :index
    live "/new_head_subscriptions", NewHeadSubscriptionLive, :index
    live "/transactions", TransactionSubscriptionLive, :index
    live "/tokens", TokenLive, :index
    live "/money_markets", MoneyMarketLive, :index
    live "/amm", AmmLive, :index
    live "/future_swap", FutureSwapLive, :index
    live "/chainlink", ChainlinkLive, :index
    live "/keep3r", Keep3rLive, :index
    live "/alerts", AlertLive, :index
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RubeWeb.Telemetry
    end
  end
end
