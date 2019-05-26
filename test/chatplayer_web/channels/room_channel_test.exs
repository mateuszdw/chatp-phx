defmodule ChatplayerWeb.RoomChannelTest do
  use ChatplayerWeb.ChannelCase
  alias ChatplayerWeb.RoomChannel
  import Chatplayer.Factory
  import Chatplayer.UserManager.Guardian

  describe "when connected" do

    setup do
      user = insert(:user)
      # {:ok, token, _full_claims} = encode_and_sign(user)
      # {:ok, socket} = ChatplayerWeb.UserSocket.connect(%{}, socket)
      {:ok, _, socket} = subscribe_and_join(socket, RoomChannel, "room:123", %{artist: "pearl jam"})
      {:ok, socket: socket, user: user}
    end

    test "current_user is assign", %{socket: socket, user: user} do
      assert socket.assigns.current_user == user
    end

    test "ping replies with status ok", %{socket: socket} do
      ref = push socket, "ping", %{"hello" => "there"}
      assert_reply ref, :ok, %{"hello" => "there"}
    end

    test "shout broadcasts to room:lobby", %{socket: socket} do
      {:ok, _, socket} = subscribe_and_join(socket, RoomChannel, "room:purgatory")
      push socket, "shout", %{"hello" => "all"}
      assert_broadcast "shout", %{"hello" => "all"}
    end

    test "broadcasts are pushed to the client", %{socket: socket} do
      broadcast_from! socket, "broadcast", %{"some" => "data"}
      assert_push "broadcast", %{"some" => "data"}
    end
  end

  describe "when token invalid" do
    test "connect", %{socket: socket} do
      {:ok, response} = ChatplayerWeb.UserSocket.connect(%{token: ""}, socket)
      assert response == %{reason: "unauthorized"}
    end
  end
end
