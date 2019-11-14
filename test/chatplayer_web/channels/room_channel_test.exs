defmodule ChatplayerWeb.RoomChannelTest do
  use ChatplayerWeb.ChannelCase
  alias ChatplayerWeb.UserSocket
  alias Chatplayer.Api
  import Chatplayer.Factory
  import Chatplayer.UserManager.Guardian

  describe "when token valid" do
    setup do
      user = insert(:user)
      room = insert(:room)
      {:ok, token, _full_claims} = encode_and_sign(user)
      {:ok, socket} = connect(UserSocket, %{"token" => token})
      {:ok, socket: socket, user: user, room: room}
    end

    test "can join room", %{socket: socket, user: _user, room: room} do
      {:ok, reply, _socket} = subscribe_and_join(socket, "room:#{room.name}", %{})
      assert reply["data"] == %{
        "attributes" => %{"name" => room.name},
        "id" => to_string(room.id),
        "type" => "rooms"
      }
    end
    #
    test "can create and join room when not exists", %{socket: socket, user: _user, room: _room} do
      {:ok, reply, _socket} = subscribe_and_join(socket, "room:0000", %{})
      assert reply["data"] == %{
        "attributes" => %{"name" => "0000"},
        "id" => to_string(Api.get_last_room.id),
        "type" => "rooms"
      }
    end

    # test "when connected to room", %{socket: socket, user: user, room: room} do
    #   {:ok, reply, socket} = subscribe_and_join(socket, "room:#{room.id}", %{})
    #   ref = push socket, "ping", %{"hello" => "there"}
    #   assert_reply ref, :ok, %{"hello" => "there"}
    # end
  #
  #   test "can broadcasts are pushed to the client", %{socket: socket} do
  #     broadcast_from! socket, "broadcast", %{"some" => "data"}
  #     assert_push "broadcast", %{"some" => "data"}
  #   end

    test "when user logged in can broadcasts to room", %{socket: socket, user: _user, room: room} do
      {:ok, _reply, socket} = subscribe_and_join(socket, "room:#{room.id}", %{})
      push socket, "new_msg", %{"message" => "some message"}
      assert_broadcast "shout", %{"message" => "some message"}
    end
  end
  #
  # describe "when token empty" do
  #   test "can join room", %{socket: socket} do
  #     {:ok, reply, socket} = subscribe_and_join(socket, RoomChannel, "room:21231321")
  #     assert reply == ""
  #   end
  #
  #   test "cannot broadcast message"
  # end
end
