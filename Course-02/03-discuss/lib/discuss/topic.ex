defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    timestamps()
  end

  def create_changeset(params) do
    %Discuss.Topic{}
    |> cast(params, [:title])
    |> validate_required([:title])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
