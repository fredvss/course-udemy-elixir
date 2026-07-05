defmodule PhoenixHelloWeb.HelloControllerTest do
  use PhoenixHelloWeb.ConnCase, async: true

  test "GET /api/hello retorna JSON de boas-vindas", %{conn: conn} do
    conn = get(conn, ~p"/api/hello")
    assert %{"message" => "Olá do Phoenix!", "version" => _} = json_response(conn, 200)
  end

  test "GET /api/hello/:name personaliza a mensagem", %{conn: conn} do
    conn = get(conn, ~p"/api/hello/Elixir")
    assert json_response(conn, 200) == %{"message" => "Olá, Elixir!", "framework" => "Phoenix"}
  end
end
