defmodule TestBank.Accounts.Create do
  alias TestBank.Accounts.Account
  alias TestBank.Repo

  # TODO - fazer validacao que o usuario realmente existe antes de criar a conta
  def call(params) do
    params
    |> Account.changeset()
    |> Repo.insert()
  end
end
