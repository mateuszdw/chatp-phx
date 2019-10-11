defmodule ChatplayerWeb.MsgControllerTest do
  use ChatplayerWeb.ConnCase

  alias Chatplayer.Api
  alias Chatplayer.Api.Msg

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:msg) do
    {:ok, msg} = Api.create_msg(@create_attrs)
    msg
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all msgs", %{conn: conn} do
      conn = get conn, msg_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create msg" do
    test "renders msg when data is valid", %{conn: conn} do
      conn = post conn, msg_path(conn, :create), msg: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, msg_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "content" => "some content"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, msg_path(conn, :create), msg: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update msg" do
    setup [:create_msg]

    test "renders msg when data is valid", %{conn: conn, msg: %Msg{id: id} = msg} do
      conn = put conn, msg_path(conn, :update, msg), msg: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, msg_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "content" => "some updated content"}
    end

    test "renders errors when data is invalid", %{conn: conn, msg: msg} do
      conn = put conn, msg_path(conn, :update, msg), msg: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete msg" do
    setup [:create_msg]

    test "deletes chosen msg", %{conn: conn, msg: msg} do
      conn = delete conn, msg_path(conn, :delete, msg)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, msg_path(conn, :show, msg)
      end
    end
  end

  defp create_msg(_) do
    msg = fixture(:msg)
    {:ok, msg: msg}
  end
end
