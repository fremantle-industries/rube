defmodule RubeWeb.HomeLiveTest do
  use RubeWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, home_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Overview Dashboard"
    assert render(home_live) =~ "Overview Dashboard"
  end
end
