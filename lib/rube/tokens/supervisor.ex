defmodule Rube.Tokens.Supervisor do
  use Supervisor
  alias Rube.Tokens

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      Tokens.TokenStore,
      Tokens.TokenBuilder,
      Tokens.TokenIndexer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
