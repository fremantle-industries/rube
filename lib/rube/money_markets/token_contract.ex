defmodule Rube.MoneyMarkets.TokenContract do
  @symbol_abi %{
    "inputs" => [],
    "name" => "symbol",
    "outputs" => [%{"internalType" => "string", "name" => "", "type" => "string"}],
    "stateMutability" => "view",
    "type" => "function"
  }
  def symbol(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [symbol]} <-
           Slurp.Adapter.call(blockchain, address, @symbol_abi, [], %{}, endpoint) do
      {:ok, symbol}
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
end
