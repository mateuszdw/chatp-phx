defmodule ChatplayerWeb.MsgController do
  use ChatplayerWeb, :controller

  alias Chatplayer.Api
  alias Chatplayer.Api.Msg

  action_fallback ChatplayerWeb.FallbackController

  def index(conn, _params) do
    msgs = Api.list_msgs()
    render(conn, "index.json", msgs: msgs)
  end

  def create(conn, %{"msg" => msg_params}) do
    with {:ok, %Msg{} = msg} <- Api.create_msg(msg_params) do
      conn
      |> put_status(:created)
      |> render("show.json", msg: msg)
    end
  end

  def show(conn, %{"id" => id}) do
    msg = Api.get_msg!(id)
    render(conn, "show.json", msg: msg)
  end

  def update(conn, %{"id" => id, "msg" => msg_params}) do
    msg = Api.get_msg!(id)

    with {:ok, %Msg{} = msg} <- Api.update_msg(msg, msg_params) do
      render(conn, "show.json", msg: msg)
    end
  end

  def delete(conn, %{"id" => id}) do
    msg = Api.get_msg!(id)
    with {:ok, %Msg{}} <- Api.delete_msg(msg) do
      send_resp(conn, :no_content, "")
    end
  end
end
