defmodule ChatplayerWeb.RoomController do
  use ChatplayerWeb, :controller

  alias Chatplayer.Api
  alias Chatplayer.Api.Room

  action_fallback ChatplayerWeb.FallbackController

  def index(conn, _params) do
    rooms = Api.list_rooms()
    render(conn, "index.json-api", data: rooms)
  end

  def create(conn, %{"data" => data}) do
    room_params = JaSerializer.Params.to_attributes(data)
    with {:ok, %Room{} = room} <- Api.create_room(room_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", room_path(conn, :show, room))
      |> render("show.json-api", data: room)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Api.get_room!(id)
    render(conn, "show.json-api", data: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Api.get_room!(id)

    with {:ok, %Room{} = room} <- Api.update_room(room, room_params) do
      render(conn, "show.json-api", data: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Api.get_room!(id)
    with {:ok, %Room{}} <- Api.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
