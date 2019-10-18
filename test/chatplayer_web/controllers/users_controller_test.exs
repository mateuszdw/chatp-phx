defmodule Chatplayer.UsersControllerTest do
  use ChatplayerWeb.ConnCase
  import Chatplayer.Factory
  import Chatplayer.UserManager
  import Chatplayer.UserManager.Guardian

  describe "POST /sign_in" do
    test "renders user when credentials are valid", %{conn: conn} do
      user = insert(:user)

      request =
        conn
        |> post(users_path(conn, :sign_in), %{"data" => %{"attributes" => %{"email" => user.email, "password" => "password"}}})

      response =
        request
        |> json_response(200)

      auth_header =
        request
        |> get_resp_header("authorization")

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
      assert auth_header != nil
    end

    test "render error when user credentials invalid", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> post(users_path(conn, :sign_in), %{"data" => %{"attributes" => %{"email" => user.email, "password" => "badpassword"}}})
        |> json_response(401)

      assert response["errors"] != nil
    end
  end

  describe "POST /sign_up" do
    test "renders user when data is valid", %{conn: conn} do
      user = params_for(:user)

      response =
        conn
        |> post(users_path(conn, :sign_up), %{
          "data" => %{
            "attributes" => %{
              "email" => user.email,
              "name" => user.name,
              "password" => "password",
              "password_confirmation" => "password"
            }
          }
        })
        |> json_response(201)

      expected = %{
        "data" => %{
          "attributes" => %{
            "email" => user.email,
            "name" => user.name
          },
          "id" => to_string(get_last_user().id),
          "type" => "users"
        },
        "jsonapi" => %{"version" => "1.0"}
      }

      assert response == expected
    end

    test "render error when data is invalid", %{conn: conn} do
      user = params_for(:user)

      response =
        conn
        |> post(users_path(conn, :sign_up), %{
          "data" => %{
            "attributes" => %{
              "email" => user.email,
              "name" => user.name
            }
          }
        })
        |> json_response(422)

      assert response["errors"] != nil
    end
  end

  describe "GET /users/me" do
    test "renders user when authenticated", %{conn: conn} do
      user = insert(:user)
      {:ok, jwt, _full_claims} = encode_and_sign(user)
      response =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get("/users/me")
        |> json_response(200)

      expected = %{
        "data" => %{
          "attributes" => %{
            "email" => user.email,
            "name" => user.name
          },
          "id" => to_string(get_last_user().id),
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
        |> get("/users/me")
        |> json_response(401)

      assert response["errors"] != nil
    end
  end

end
