defmodule Chatplayer.UsersControllerTest do
  use ChatplayerWeb.ConnCase
  import Chatplayer.Factory
  # import Chatplayer.Guardian

  describe "POST /sign_in" do
    test "renders user when credentials are valid", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> post(users_path(conn, :sign_in), %{"user" => %{"email" => user.email, "password" => "password"}})
        |> json_response(200)

      expected = %{
        "data" => %{
          "attributes" => %{
            "email" => user.email,
            "name" => user.name
          },
          "id" => to_string(user.id),
          "type" => "users"
        },
        "jsonapi" => %{"version" => "1.0"}
      }
      assert response == expected
    end

    test "render error when user credentials invalid", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> post(users_path(conn, :sign_in), %{"user" => %{"email" => user.email, "password" => "badpassword"}})
        |> json_response(401)

      assert response[:errors] == nil
    end
  end

  describe "POST /sign_up" do
    test "renders user when data is valid", %{conn: conn} do

      response =
        conn
        |> post(users_path(conn, :sign_up), %{"user" => %{"username" => "username", "password" => "password"}})
        |> json_response(200)

      expected = %{
        "data" => [
          %{ "name" => "user1.name", "email" => "user1.email" },
          %{ "name" => "user2.name", "email" => "user2.email" }
        ]
      }

      assert response == expected
    end
  end

end
