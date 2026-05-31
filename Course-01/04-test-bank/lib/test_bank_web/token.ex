defmodule TestBankWeb.Token do

  alias Phoenix.Token
  alias TestBankWeb.Endpoint

  @sign_salt "test_bank_api"

  def sign(user) do
    Token.sign(Endpoint, @sign_salt, %{user_id: user.id})
  end

  def verify(token), do: Token.verify(Endpoint, @sign_salt, token, max_age: 3600)
end
