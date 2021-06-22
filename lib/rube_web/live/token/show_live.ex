defmodule RubeWeb.Token.ShowLive do
  use RubeWeb, :live_view
  # import SlurpeeWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]
  # import RubeWeb.ExplorerHelpers, only: [explorer_address_link: 3]
  # import Stylish.Ellipsis, only: [ellipsis: 2]
  # import Stylish.CopyButton, only: [copy_button: 1]

  @impl true
  def mount(_params, _session, socket) do
    # Phoenix.PubSub.subscribe(Slurpee.PubSub, "after_put_token")

    # socket =
    #   socket
    #   |> assign(:query, nil)
    #   |> assign(latest_token: nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(
        %{"blockchain_id" => blockchain_id, "address" => address} = _params,
        _uri,
        socket
      ) do
    {:ok, token} = Rube.Tokens.find(blockchain_id, address)

    socket =
      socket
      |> assign(:blockchain_id, blockchain_id)
      |> assign(:address, address)
      |> assign(:token, token)

    {:noreply, socket}
  end
end
