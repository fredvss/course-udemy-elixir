# arquivo único, ponto de entrada por contexto
defmodule TestBank.Accounts do
  alias TestBank.Accounts.Create
  alias TestBank.Accounts.Transaction

  defdelegate create(params), to: Create, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
