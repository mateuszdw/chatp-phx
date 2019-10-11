defmodule ChatplayerWeb.UsersRestController do
  use ChatplayerWeb, :controller

  alias Chatplayer.{UserManager, UserManager.User, UserManager.Guardian}
  action_fallback ChatplayerWeb.FallbackRestController

  def profile(conn,_) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> render("show.json", user: user)
  end

  def sign_up(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserManager.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def sign_in(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- UserManager.authenticate_user(email, password) do
      new_conn = Guardian.Plug.sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)
      claims = Guardian.Plug.current_claims(new_conn)
      exp = Map.get(claims, "exp")

      new_conn
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")
      |> put_status(:ok)
      |> render("show.json", user: user, token: jwt)
    end
  end

  def logout_rest(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
  end

  defp login_reply({:ok, user}, conn) do
    conn
    # |> put_flash(:success, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> put_status(:ok)

    # |> redirect(to: "/secret")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_status(:error)
    # |> render(:error, to_string(reason))
    # |> new(%{})
  end
end
