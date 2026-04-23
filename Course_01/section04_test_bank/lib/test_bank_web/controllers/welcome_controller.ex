defmodule TestBankWeb.WelcomeController do
  use TestBankWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Bem vindo ao TestBank"})
  end

end
