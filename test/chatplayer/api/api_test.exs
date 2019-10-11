defmodule Chatplayer.ApiTest do
  use Chatplayer.DataCase

  alias Chatplayer.Api

  describe "rooms" do
    alias Chatplayer.Api.Room

    @room_name "some name"
    @valid_attrs %{name: @room_name}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_room()

      room
    end

    test "find_or_create_by_name/1 when room exist" do
      room_fixture()
      result = Api.find_or_create_by_name(@room_name)
      assert result.name == @room_name
    end

    test "find_or_create_by_name/1 when room not exists" do
      result = Api.find_or_create_by_name(@room_name)
      assert result.name == @room_name
    end

    test "get_room_by_name/1 returns room with given name" do
      room = room_fixture()
      assert Api.get_room_by_name(@room_name) == room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Api.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Api.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Api.create_room(@valid_attrs)
      assert room.name == "some name"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = Api.update_room(room, @update_attrs)
      assert %Room{} = room
      assert room.name == "some updated name"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_room(room, @invalid_attrs)
      assert room == Api.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Api.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Api.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Api.change_room(room)
    end
  end

  describe "msgs" do
    alias Chatplayer.Api.Msg

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def msg_fixture(attrs \\ %{}) do
      {:ok, msg} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Api.create_msg()

      msg
    end

    test "list_msgs/0 returns all msgs" do
      msg = msg_fixture()
      assert Api.list_msgs() == [msg]
    end

    test "get_msg!/1 returns the msg with given id" do
      msg = msg_fixture()
      assert Api.get_msg!(msg.id) == msg
    end

    test "create_msg/1 with valid data creates a msg" do
      assert {:ok, %Msg{} = msg} = Api.create_msg(@valid_attrs)
      assert msg.content == "some content"
    end

    test "create_msg/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Api.create_msg(@invalid_attrs)
    end

    test "update_msg/2 with valid data updates the msg" do
      msg = msg_fixture()
      assert {:ok, msg} = Api.update_msg(msg, @update_attrs)
      assert %Msg{} = msg
      assert msg.content == "some updated content"
    end

    test "update_msg/2 with invalid data returns error changeset" do
      msg = msg_fixture()
      assert {:error, %Ecto.Changeset{}} = Api.update_msg(msg, @invalid_attrs)
      assert msg == Api.get_msg!(msg.id)
    end

    test "delete_msg/1 deletes the msg" do
      msg = msg_fixture()
      assert {:ok, %Msg{}} = Api.delete_msg(msg)
      assert_raise Ecto.NoResultsError, fn -> Api.get_msg!(msg.id) end
    end

    test "change_msg/1 returns a msg changeset" do
      msg = msg_fixture()
      assert %Ecto.Changeset{} = Api.change_msg(msg)
    end
  end
end
