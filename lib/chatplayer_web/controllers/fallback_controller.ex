# defmodule ChatplayerWeb.FallbackController do
#   @moduledoc """
#   Translates controller action results into valid `Plug.Conn` responses.
#
#   See `Phoenix.Controller.action_fallback/1` for more details.
#   """
#   use ChatplayerWeb, :controller
#
#   def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
#     conn
#     |> put_status(:unprocessable_entity)
#     |> render(ChatplayerWeb.ChangesetView, "error.json", changeset: changeset)
#   end
#
#   def call(conn, {:error, :not_found}) do
#     conn
#     |> put_status(:not_found)
#     |> render(ChatplayerWeb.ErrorView, :"404")
#   end
# end


defmodule ChatplayerWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, status}) when is_atom(status) do
    code = Plug.Conn.Status.code(status)
    phrase = Plug.Conn.Status.reason_phrase(code)

    conn
    |> put_status(status)
    |> render(
      :errors,
      data: %{
        id: "#{code}",
        title: "#{code} #{phrase}",
        status: code
      }
    )
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(:errors, data: changeset)
  end
end
