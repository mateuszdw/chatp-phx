defmodule Chatplayer.UsersControllerTest do
  use ChatplayerWeb.ConnCase

  # alias Chatplayer.Auth
  # alias Chatplayer.Auth.User
  alias Plug.Test

  describe "POST /login" do
    test "renders user when data is valid", %{conn: conn} do

      response =
        conn
        |> get(users_path(conn, :login), %{"user" => %{"username" => "username", "password" => "password"}})
        |> json_response(200)

      expected = %{
        "data" => [
          %{ "name" => "user1.name", "email" => "user1.email" },
          %{ "name" => "user2.name", "email" => "user2.email" }
        ]
      }

      assert response == expected

      # conn = post(conn, Routes.users_path(conn, :login))
      #
      # assert %{
      #          "id" => id,
      #          "email" => "some email",
      #          "password" => "somepassword"
      #        } = json_response(conn, 200)["data"]
    end
  end

  # describe "update user" do
  #   # ...
  #   test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
  #     # ...
  #     assert %{
  #              "id" => id,
  #              "email" => "some updated email",
  #              "is_active" => false
  #            } = json_response(conn, 200)["data"]
  #   end
  #   # ...
  # end
  # # ...
end
