defmodule TestBank.Users.Delete do
  alias TestBank.Users.User
  alias TestBank.Repo

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> Repo.delete(user)
    end
  end

end
