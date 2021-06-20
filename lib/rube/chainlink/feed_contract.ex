defmodule Rube.Chainlink.FeedContract do
  @description_abi %{
    "inputs" => [],
    "name" => "description",
    "outputs" => [%{"internalType" => "string", "name" => "", "type" => "string"}],
    "stateMutability" => "view",
    "type" => "function"
  }
  def description(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [description]} <-
           Slurp.Adapter.call(blockchain, address, @description_abi, [], %{}, endpoint) do
      {:ok, description}
    end
  end

  @version_abi %{
    "inputs" => [],
    "name" => "version",
    "outputs" => [%{"internalType" => "uint256", "name" => "", "type" => "uint256"}],
    "stateMutability" => "view",
    "type" => "function"
  }
  def version(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [version]} <-
           Slurp.Adapter.call(blockchain, address, @version_abi, [], %{}, endpoint) do
      {:ok, version}
    end
  end

  @check_enabled_abi %{
    "inputs" => [],
    "name" => "checkEnabled",
    "outputs" => [
      %{
        "internalType" => "bool",
        "name" => "",
        "type" => "bool"
      }
    ],
    "stateMutability" => "view",
    "type" => "function"
  }
  def check_enabled(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [enabled]} <-
           Slurp.Adapter.call(blockchain, address, @check_enabled_abi, [], %{}, endpoint) do
      {:ok, enabled}
    end
  end

  @decimals_abi %{
    "inputs" => [],
    "name" => "decimals",
    "outputs" => [
      %{
        "internalType" => "uint8",
        "name" => "",
        "type" => "uint8"
      }
    ],
    "stateMutability" => "view",
    "type" => "function"
  }
  def decimals(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [decimals]} <-
           Slurp.Adapter.call(blockchain, address, @decimals_abi, [], %{}, endpoint) do
      {:ok, decimals}
    end
  end

  @latest_answer_abi %{
    "inputs" => [],
    "name" => "latestAnswer",
    "outputs" => [
      %{
        "internalType" => "int256",
        "name" => "",
        "type" => "int256"
      }
    ],
    "stateMutability" => "view",
    "type" => "function"
  }
  def latest_answer(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [latest_answer]} <-
           Slurp.Adapter.call(blockchain, address, @latest_answer_abi, [], %{}, endpoint) do
      {:ok, latest_answer}
    end
  end

  @latest_round_abi %{
    "inputs" => [],
    "name" => "latestRound",
    "outputs" => [
      %{
        "internalType" => "uint256",
        "name" => "",
        "type" => "uint256"
      }
    ],
    "stateMutability" => "view",
    "type" => "function"
  }
  def latest_round(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [latest_round]} <-
           Slurp.Adapter.call(blockchain, address, @latest_round_abi, [], %{}, endpoint) do
      {:ok, latest_round}
    end
  end
end
