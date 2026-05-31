defmodule TestBankWeb.UsersJSON do
  alias TestBank.Users.User

  def create(%{user: user}) do
    %{
      message: "User successfully created!",
      data: data(user)
    }
  end

  # Usando derivativa - @derive {Jason.Encoder, only: [:id, :name, :email, :cep]} || O proclema é que não fica algo
  # explicito como a funcao data
  def delete(%{user: user}), do: %{data: user}

  def get(%{user: user}), do: %{data: user}

  def update(%{user: user}), do: %{message: "User successufully updated", data: user}

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      cep: user.cep,
      email: user.email
    }
  end

  def login(%{token: token}) do
    %{
      message: "User successfully authenticated",
      bearer: token
    }
  end
end
