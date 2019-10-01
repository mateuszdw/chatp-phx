defmodule ChatplayerWeb.RoomChannel do
  use ChatplayerWeb, :channel
  alias Chatplayer.{Api, UserManager, UserManager.User, UserManager.Guardian}
  alias ChatplayerWeb.{UsersView, RoomsView}

  # this channel is public
  # def join("room:purgatory", _message, socket) do
  #   {:ok, socket}
  # end
  def join("room:" <> name, params, socket) do
    case Api.find_or_create_by_name(name) do
      nil -> {:error, %{reason: "not found"}}
      room -> {:ok, JaSerializer.format(RoomsView, room), socket}
    end
  end

  # def join("room:" <> room_slug, params, socket) do
    # IO.inspect room_slug
    # IO.inspect params
    # Api.get_room!(room_id)
    # user = socket.assigns.current_user
    # user = UserManager.get_last_user
    # serializer = JaSerializer.format(RoomView, user)
    # if user do
    #   {:ok, serializer, socket}
    # else
    #   {:error, %{reason: "authorization required to enter this room #{room_id}"}}
    # end
  # end
  # this room is for user which don't have correct room_id
  # def join("room:purgatory", _message, socket) do
  #
  # end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    if user = socket.assigns.current_user do
      # IO.inspect user
      broadcast(socket, "shout", payload)
      {:reply, {:ok, payload}, socket}
    else
      {:error, %{reason: "not logged in"}}
    end
  end
end