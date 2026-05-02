defmodule ExamplePhoenixWeb.WelcomeController do
  use ExamplePhoenixWeb, :controller

  def index(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "Welcome"})
  end
end
