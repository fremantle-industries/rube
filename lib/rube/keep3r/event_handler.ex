defmodule Rube.Keep3r.EventHandler do
  alias Rube.Keep3r
  alias Rube.Keep3r.Events
  require Logger

  def handle_event(blockchain, %{"address" => address}, %Events.KeeperWorked{} = event) do
    Logger.warn("unhandled keep3r event: #{inspect(event)}")
  end
end
