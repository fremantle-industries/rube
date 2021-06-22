defmodule RubeWeb.TokenHelpers do
  import Stylish.Ellipsis, only: [ellipsis: 2]

  def token_name(blockchain_id, address, opts) do
    case Rube.Tokens.find(blockchain_id, address) do
      {:ok, token} -> token.symbol
      {:error, :not_found} -> ellipsis(address, 18)
    end
  end
end
