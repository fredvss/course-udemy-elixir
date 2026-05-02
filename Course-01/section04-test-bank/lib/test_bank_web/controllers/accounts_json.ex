defmodule TestBankWeb.AccountsJSON do
  alias TestBank.Accounts.Account

  def create(%{account: account}) do
    %{
      message: "Account successfully created!",
      data: data(account)
    }
  end

  def transaction(%{transaction: %{withdraw: from_account, deposit: to_account}}) do
    %{
      message: "Transfer completed successfully!",
      from_account: data(from_account),
      to_account: data(to_account)
    }
  end

  defp data(%Account{} = account) do
    %{
      id: account.id,
      balance: account.balance,
      user_id: account.user_id
    }
  end
end
