defmodule ChatplayerWeb.UserSocketTest do
  use ChatplayerWeb.ChannelCase
  alias ChatplayerWeb.RoomChannel
  import Chatplayer.Factory

  describe "connection can be established" do

    test "without params" do
      response = ChatplayerWeb.UserSocket.connect(%{}, socket)
      assert response == {:ok, socket}
    end

    test "with params" do
      response = ChatplayerWeb.UserSocket.connect(%{someparam: "someparam"}, socket)
      assert response == {:ok, socket}
    end

  end
end
