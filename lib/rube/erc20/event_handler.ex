defmodule Rube.Erc20.EventHandler do
  require Logger

  def handle_event(blockchain, %{"address" => address}, %Rube.Erc20.Events.Transfer{}) do
    case Rube.Tokens.find(blockchain.id, address) do
      {:error, :not_found} ->
        Rube.Tokens.fetch_and_store(blockchain.id, address)

      _ ->
        nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Rube.Erc20.Events.Mint{}) do
    case Rube.Tokens.find(blockchain.id, address) do
      {:error, :not_found} ->
        Rube.Tokens.fetch_and_store(blockchain.id, address)

      _ ->
        nil
    end
  end

  def handle_event(blockchain, %{"address" => address}, %Rube.Erc20.Events.Burn{}) do
    case Rube.Tokens.find(blockchain.id, address) do
      {:error, :not_found} ->
        Rube.Tokens.fetch_and_store(blockchain.id, address)

      _ ->
        nil
    end
  end
end
