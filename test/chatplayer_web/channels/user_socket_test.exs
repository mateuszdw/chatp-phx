defmodule ChatplayerWeb.UserSocketTest do
  use ChatplayerWeb.ChannelCase
  alias ChatplayerWeb.RoomChannel
  alias ChatplayerWeb.UserSocket
  import Chatplayer.Factory
  import Chatplayer.UserManager.Guardian

  describe "connection can be established" do

    setup do
      user = insert(:user)
      {:ok, token, _full_claims} = encode_and_sign(user)
      {:ok, socket: socket(), user: user, token: token}
    end

    test "with token", %{socket: socket, user: user, token: token} do
      {:ok, response} = UserSocket.connect(%{"token" => token}, socket)
      assert response.assigns.current_user == user
    end

    test "with empty token", %{socket: socket, user: user} do
      {:ok, response} = UserSocket.connect(%{"token" => ""}, socket)
      assert response == socket
    end

  end
end
