defmodule ChatplayerWeb.RoomControllerTest do
  use ChatplayerWeb.ConnCase

  alias Chatplayer.Api
  alias Chatplayer.Api.Room

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:room) do
    {:ok, room} = Api.create_room(@create_attrs)
    room
  end

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get conn, room_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create room" do
    test "renders room when data is valid", %{conn: conn} do
      conn = post conn, room_path(conn, :create), data: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, room_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => "#{id}",
        "type" => "room",
        "attributes" => %{
          "name" => "some name"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, room_path(conn, :create), room: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update room" do
    setup [:create_room]

    test "renders room when data is valid", %{conn: conn, data: %Room{id: id} = room} do
      conn = put conn, room_path(conn, :update, room), data: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, room_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => "#{id}",
        "type" => "room",
        "attributes" => %{
          "name" => "some name"
        }
      }
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put conn, room_path(conn, :update, room), room: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete conn, room_path(conn, :delete, room)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, room_path(conn, :show, room)
      end
    end
  end

  defp create_room(_) do
    room = fixture(:room)
    {:ok, room: room}
  end
end
