defmodule PhoenixHelloWeb.HelloController do
  use PhoenixHelloWeb, :controller

  def show(conn, %{"name" => name}) do
    json(conn, %{message: "Olá, #{name}!", framework: "Phoenix"})
  end

  def show(conn, _params) do
    json(conn, %{message: "Olá do Phoenix!", version: to_string(Application.spec(:phoenix, :vsn))})
  end
end
