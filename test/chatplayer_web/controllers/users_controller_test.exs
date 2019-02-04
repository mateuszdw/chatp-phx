defmodule Chatplayer.UsersControllerTest do
  use ChatplayerWeb.ConnCase

  alias Chatplayer.UserManager
  alias Chatplayer.UserManager.User
  # alias Plug.Test

  describe "POST /login" do
    test "renders user when data is valid", %{conn: conn} do

      response =
        conn
        |> post(users_path(conn, :login), %{"user" => %{"username" => "username", "password" => "password"}})
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

  describe "POST /sign_up" do
    test "renders user when data is valid", %{conn: conn} do

      response =
        conn
        |> post(users_path(conn, :create), %{"user" => %{"username" => "username", "password" => "password"}})
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
