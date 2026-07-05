defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  def new(conn, _params) do
    changeset = Topic.create_changeset(%{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = Topic.create_changeset(topic_params)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created!")
        |> redirect(to: ~p"/")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
