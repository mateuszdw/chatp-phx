defmodule ChatplayerWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, status}) when is_atom(status) do
    code = Plug.Conn.Status.code(status)
    phrase = Plug.Conn.Status.reason_phrase(code)

    conn
    |> put_status(status)
    |> render(
      "errors.json-api",
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
    |> render("errors.json-api", data: changeset)
  end
end
