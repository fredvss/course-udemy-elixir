defmodule TestBank.Repo do
  use Ecto.Repo,
    otp_app: :test_bank,
    adapter: Ecto.Adapters.Postgres
end
