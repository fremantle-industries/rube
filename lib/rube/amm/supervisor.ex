defmodule Rube.Amm.Supervisor do
  use Supervisor
  alias Rube.Amm

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      Amm.PairStore,
      Amm.PairBuilder,
      Amm.PairIndexer
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
