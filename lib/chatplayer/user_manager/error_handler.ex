defmodule Chatplayer.UserManager.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    _body = to_string(type)
    conn
    |> put_resp_content_type("application/vnd.api+json")
    |> send_resp(401, Jason.encode!(%{errors: %{detail: "Access denied"}}))
  end
end
