defmodule Rube.Amm.PairContract do
  @get_reserves_abi %{
    "constant" => true,
    "inputs" => [],
    "name" => "getReserves",
    "outputs" => [
      %{
        "internalType" => "uint112",
        "name" => "_reserve0",
        "type" => "uint112"
      },
      %{
        "internalType" => "uint112",
        "name" => "_reserve1",
        "type" => "uint112"
      },
      %{
        "internalType" => "uint32",
        "name" => "_blockTimestampLast",
        "type" => "uint32"
      }
    ],
    "payable" => false,
    "stateMutability" => "view",
    "type" => "function"
  }
  def get_reserves(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, reserves} <-
           Slurp.Adapter.call(
             blockchain,
             address,
             @get_reserves_abi,
             [],
             %{},
             endpoint
           ) do
      {:ok, reserves}
    end
  end

  @token0_abi %{
    "constant" => true,
    "inputs" => [],
    "name" => "token0",
    "outputs" => [
      %{
        "internalType" => "address",
        "name" => "",
        "type" => "address"
      }
    ],
    "payable" => false,
    "stateMutability" => "view",
    "type" => "function"
  }
  def token0(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [token_0]} <-
           Slurp.Adapter.call(blockchain, address, @token0_abi, [], %{}, endpoint) do
      {:ok, token_0}
    end
  end

  @token1_abi %{
    "constant" => true,
    "inputs" => [],
    "name" => "token1",
    "outputs" => [
      %{
        "internalType" => "address",
        "name" => "",
        "type" => "address"
      }
    ],
    "payable" => false,
    "stateMutability" => "view",
    "type" => "function"
  }
  def token1(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [token_1]} <-
           Slurp.Adapter.call(blockchain, address, @token1_abi, [], %{}, endpoint) do
      {:ok, token_1}
    end
  end

  @k_last_abi %{
    "constant" => true,
    "inputs" => [],
    "name" => "kLast",
    "outputs" => [
      %{
        "internalType" => "uint256",
        "name" => "",
        "type" => "uint256"
      }
    ],
    "payable" => false,
    "stateMutability" => "view",
    "type" => "function"
  }
  def k_last(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [k_last]} <-
           Slurp.Adapter.call(blockchain, address, @k_last_abi, [], %{}, endpoint) do
      {:ok, k_last}
    end
  end

  @price0_cumulative_last_abi %{
    "constant" => true,
    "inputs" => [],
    "name" => "price0CumulativeLast",
    "outputs" => [
      %{
        "internalType" => "uint256",
        "name" => "",
        "type" => "uint256"
      }
    ],
    "payable" => false,
    "stateMutability" => "view",
    "type" => "function"
  }
  def price0_cumulative_last(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [price_0_cumulative_last]} <-
           Slurp.Adapter.call(
             blockchain,
             address,
             @price0_cumulative_last_abi,
             [],
             %{},
             endpoint
           ) do
      {:ok, price_0_cumulative_last}
    end
  end

  @price1_cumulative_last_abi %{
    "constant" => true,
    "inputs" => [],
    "name" => "price1CumulativeLast",
    "outputs" => [
      %{
        "internalType" => "uint256",
        "name" => "",
        "type" => "uint256"
      }
    ],
    "payable" => false,
    "stateMutability" => "view",
    "type" => "function"
  }
  def price1_cumulative_last(blockchain, address) do
    with endpoint <- blockchain.rpc |> List.first(),
         {:ok, [price_1_cumulative_last]} <-
           Slurp.Adapter.call(
             blockchain,
             address,
             @price1_cumulative_last_abi,
             [],
             %{},
             endpoint
           ) do
      {:ok, price_1_cumulative_last}
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
