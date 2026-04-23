defmodule TestBankWeb.UsersControllerTest do
  use TestBankWeb.ConnCase

  alias TestBank.Users
  alias Users.User

  describe "create/2" do
    test "user successfully created", %{conn: conn} do

      params = %{
        name: "Joao",
        cep: "12341234",
        email: "joao@email.com",
        password: "joao123"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:created)

      assert %{
        "data" => %{
          "cep" => "12341234", "email" => "joao@email.com", "id" => _id, "name" => "Joao"
          },
        "message" => "User successfully created!"
      } = response
    end

    test "returning an error when there are invalid params", %{conn: conn} do

      params = %{
        name: "",
        cep: "123",
        email: "joao@email.com",
        password: "1"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      assert %{"errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}} = response
    end
  end

  describe "delete/2" do
    test "successfully delete an user", %{conn: conn} do

      params = %{
        name: "ususario_teste",
        cep: "12312345",
        email: "joao@email.com",
        password: "ususario_teste123"
      }

      {:ok, %User{id: id}} = Users.create(params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)


      expected_response = %{"data" => %{"cep" => "12312345", "email" => "joao@email.com", "id" => id, "name" => "ususario_teste"}}
      assert response == expected_response
    end
  end

end
