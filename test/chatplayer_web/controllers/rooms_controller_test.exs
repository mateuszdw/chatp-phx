defmodule ChatplayerWeb.RoomsControllerTest do
  use ChatplayerWeb.ConnCase

  alias Chatplayer.Api

  import Chatplayer.Factory
  import Chatplayer.UserManager.Guardian

  @create_attrs %{"name" => "some name"}
  @update_attrs %{"name" => "some updated name"}
  @invalid_attrs %{"name" => nil}

  setup %{conn: conn} do
    user = insert(:user)
    {:ok, token, _full_claims} = encode_and_sign(user)
    conn = conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")
      |> put_req_header("authorization", "Bearer #{token}")
    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all rooms", %{conn: conn} do
      conn = get conn, rooms_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup :insert_room

    test "one room", %{conn: conn, room: room} do
      conn = get conn, rooms_path(conn, :show, room)
      assert json_response(conn, 200)["data"] == %{
        "attributes" => %{"name" => room.name},
        "id" => to_string(room.id),
        "type" => "rooms"
      }
    end

    test "no room", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, rooms_path(conn, :show, "123213123213")
      end
      # conn =
      # assert response(conn, 404)
    end
  end

  describe "create room" do
    test "renders room when data is valid", %{conn: conn} do
      conn = post conn, rooms_path(conn, :create), data: %{attributes: @create_attrs}
      assert json_response(conn, 201)["data"] == %{
        "id" => to_string(Api.get_last_room.id),
        "type" => "rooms",
        "attributes" => @create_attrs
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, rooms_path(conn, :create), data: %{attributes: @invalid_attrs}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update room" do
    setup :insert_room

    test "renders room when data is valid", %{conn: conn, room: room} do
      conn = put conn, rooms_path(conn, :update, room), data: %{attributes: @update_attrs}
      assert json_response(conn, 200)["data"] == %{
        "id" => to_string(room.id),
        "type" => "rooms",
        "attributes" => @update_attrs
      }
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put conn, rooms_path(conn, :update, room), data: %{attributes: @invalid_attrs}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete room" do
    setup :insert_room

    test "deletes chosen room", %{conn: conn, room: room} do
      conn_delete_response = delete conn, rooms_path(conn, :delete, room)
      assert response(conn_delete_response, 204)
      assert_error_sent 404, fn ->
        get conn, rooms_path(conn, :show, room)
      end
    end
  end

  defp insert_room(_) do
    {:ok, room: insert(:room)}
  end
end
