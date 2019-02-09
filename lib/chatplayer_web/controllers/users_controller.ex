defmodule ChatplayerWeb.UsersController do
  use ChatplayerWeb, :controller

  alias Chatplayer.{UserManager, UserManager.User, UserManager.Guardian}
  action_fallback ChatplayerWeb.FallbackController

  def new(conn, _) do
    # changeset = UserManager.change_user(%User{})
    # maybe_user = Guardian.Plug.current_resource(conn)
    #
    # with {:ok, %User{} = user} <- Repo.insert(changeset) do
    #   conn
    #   |> put_status(:created)
    #   # |> put_resp_header("location", user_path(conn, :show, user))
    #   |> render("show.json-api", data: user)
    # end

    # if maybe_user do
    #   redirect(conn, to: "/secret")
    # else
      # render(conn, "index.json", data: changeset, action: users_path(conn, :login))
    # end
  end

  def profile(conn,_) do
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> render("show.json-api", data: user)
  end

  def sign_up(conn, %{"data" => data}) do
    user_params = JaSerializer.Params.to_attributes(data)
    with {:ok, %User{} = user} <- UserManager.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json-api", data: user)
    end
  end

  def sign_in(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, %User{} = user} <- UserManager.authenticate_user(email, password) do
      conn
      |> put_status(:ok)
      |> render("show.json-api", data: user)
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
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
