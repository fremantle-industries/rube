defmodule RubeWeb.ExplorerHelpers do
  import Stylish.ExternalLink, only: [external_link: 1]

  def explorer_address_link(blockchain_id, address, opts) do
    {:ok, blockchain} = Slurp.Blockchains.find(blockchain_id)
    url = Slurp.Explorer.address_url(blockchain, address)
    merged_opts = [to: url] ++ opts
    external_link(merged_opts)
  end
end
