defmodule Rube.Repo do
  use Ecto.Repo,
    otp_app: :rube,
    adapter: Ecto.Adapters.Postgres
end
