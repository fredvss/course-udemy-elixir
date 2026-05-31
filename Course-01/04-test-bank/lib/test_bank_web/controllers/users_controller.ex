defmodule TestBankWeb.UsersController do
  use TestBankWeb, :controller
  alias TestBank.Users
  alias Users.User

  alias TestBankWeb.Token

  # Primeiro modo de ter um handle nas requests
  # def create(conn, params) do
  #   params
  #   |> Create.call()
  #   |> handle_response(conn)
  # end

  # defp handle_response({:ok, user}, conn) do
  #   conn
  #   |> put_status(:created)
  #   |> render(:create, user: user)
  # end

  # defp handle_response({:error, changeset}, conn) do
  #   conn
  #   |> put_status(:bad_request)
  #   |> put_view(json: TestBankWeb.ErrorJSON)
  #   |> render(:error, changeset: changeset)
  # end

  # Refatorando handle nas requests
  # Crio somente os hndles de sucesso, pois se houve falha o erro será içado para o fallback controller,
  # caso não haja o fallback controller o phoenix nao sabe o que fazer com o erro

  action_fallback TestBankWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Users.create(params) do
      conn
      |> put_status(:created)
      |> render(:create, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.delete(id) do
      conn
      |> put_status(:ok)
      |> render(:delete, user: user)
    end
  end

  def login(conn, params) do
    with {:ok, %User{} = user} <- Users.login(params) do
      token = Token.sign(user)
      conn
      |> put_status(:ok)
      |> render(:login, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get, user: user)
    end
  end

  def update(conn, params) do
    with {:ok, %User{} = user} <- Users.update(params) do
      conn
      |> put_status(:ok)
      |> render(:update, user: user)
    end
  end
end
