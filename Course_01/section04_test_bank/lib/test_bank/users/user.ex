defmodule TestBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias TestBank.Accounts.Account

  #variavel de modulo
  @required_params_create [:name, :password, :email, :cep]
  @required_params_update [:name, :email, :cep]

  @derive {Jason.Encoder, only: [:id, :name, :email, :cep]}
  schema "users" do
    field :name, :string
    # este campo so existirá no schema e não no banco dedado - por isso é virtual
    field :password, :string, virtual: true
    field :password_hash
    field :email, :string
    field :cep, :string
    has_one :account, Account

    timestamps()
  end

  # preciso ter essa func devido ao import Ecto.Changeset - recebe dois parametros: 1 - estrutura na qual estou lidando; 2 - parametros
  # conjunto de mudancas que precisam ser realizadas, como o Ecto passa para o postgres o que precisa ser feito
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> do_validations(@required_params_create)
    |> add_password_hash()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_params_create)
    |> do_validations(@required_params_update)
    |> add_password_hash()
  end

  defp do_validations(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 3)
    |> validate_length(:cep, is: 8)

  end

  defp add_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp add_password_hash(changeset), do: changeset

end
